const quickValues = [1, 3, 5, 10];
const pollIntervalMs = 2000;
const apiEndpoint = './api.php';
let currentData = null;

async function fetchScores() {
  const response = await fetch(`${apiEndpoint}?action=scores`, {
    cache: 'no-store'
  });

  if (!response.ok) {
    throw new Error('Unable to load scores.');
  }

  currentData = await response.json();
  return currentData;
}

async function postJson(action, teamId, payload = {}) {
  const params = new URLSearchParams({ action });
  if (teamId) {
    params.set('team', teamId);
  }

  const response = await fetch(`${apiEndpoint}?${params.toString()}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(payload)
  });

  if (!response.ok) {
    const { error } = await response.json().catch(() => ({ error: 'Update failed.' }));
    throw new Error(error || 'Update failed.');
  }

  currentData = await response.json();
  return currentData;
}

function formatUpdatedAt(updatedAt) {
  if (!updatedAt) {
    return 'Waiting for first score update';
  }

  return new Intl.DateTimeFormat(undefined, {
    dateStyle: 'medium',
    timeStyle: 'medium'
  }).format(new Date(updatedAt));
}

function createQuickButtons(teamId) {
  return quickValues
    .map(
      (value) => `
        <button class="positive" type="button" data-action="adjust" data-team-id="${teamId}" data-amount="${value}">+${value}</button>
        <button class="negative" type="button" data-action="adjust" data-team-id="${teamId}" data-amount="-${value}">-${value}</button>
      `
    )
    .join('');
}

function createAdminCard(team) {
  return `
    <section class="team-card" style="--team-color: ${team.color};">
      <div class="team-title">
        <div class="team-name">${team.name}</div>
        <div class="updated-at">Tap buttons to update</div>
      </div>
      <div class="score-box">
        <div class="score-value">${team.score}</div>
      </div>
      <div class="button-grid">
        ${createQuickButtons(team.id)}
      </div>
      <form class="custom-controls" data-action="custom-form" data-team-id="${team.id}">
        <input name="customAmount" type="number" inputmode="numeric" step="1" placeholder="Custom +/- amount" aria-label="Custom amount for ${team.name}" />
        <button class="secondary" type="submit">Apply</button>
      </form>
      <div class="card-footer">
        <span class="updated-at">Color-coded scoreboard team</span>
        <button class="warning" type="button" data-action="reset-team" data-team-id="${team.id}">Reset Team</button>
      </div>
    </section>
  `;
}

function createViewerCard(team) {
  return `
    <section class="team-card viewer-card" style="--team-color: ${team.color};">
      <div class="team-title">
        <div class="team-name">${team.name}</div>
      </div>
      <div class="score-box">
        <div class="score-value">${team.score}</div>
      </div>
    </section>
  `;
}

function renderSharedHeader(data, pageType) {
  const title = data.title || 'CVC Youth Scoreboard';
  const updatedLabel = formatUpdatedAt(data.updatedAt);
  const updateMode = pageType === 'admin' ? 'Admin controls' : 'Viewer mode';

  return `
    <div>
      <p>${updateMode}</p>
      <h1>${title}</h1>
      <p class="updated-at">Last updated: ${updatedLabel}</p>
    </div>
  `;
}

function renderAdmin(data) {
  const app = document.querySelector('#app');
  app.innerHTML = `
    <div class="page-shell">
      <header class="page-header">
        ${renderSharedHeader(data, 'admin')}
        <div class="header-actions">
          <button class="secondary" id="open-viewer-button" type="button">Open Viewer Page</button>
          <button class="warning" id="reset-all-button" type="button">Reset All Teams</button>
        </div>
      </header>
      <p class="status-text" id="status-text">Scores save to JSON automatically after each change.</p>
      <main class="team-grid">
        ${data.teams.map(createAdminCard).join('')}
      </main>
    </div>
  `;
}

function renderViewer(data) {
  const app = document.querySelector('#app');
  app.innerHTML = `
    <div class="viewer-page">
      <header class="page-header">
        ${renderSharedHeader(data, 'viewer')}
        <div class="header-actions">
          <div class="updated-at">Auto-refresh every ${pollIntervalMs / 1000} seconds</div>
        </div>
      </header>
      <main class="viewer-grid">
        ${data.teams.map(createViewerCard).join('')}
      </main>
    </div>
  `;
}

function setStatus(message) {
  const statusText = document.querySelector('#status-text');
  if (statusText) {
    statusText.textContent = message;
  }
}

async function refreshPage(pageType) {
  const data = await fetchScores();
  if (pageType === 'viewer') {
    renderViewer(data);
  } else {
    renderAdmin(data);
  }
}

async function handleAdminAction(event) {
  const actionButton = event.target.closest('button[data-action]');
  const form = event.target.closest('form[data-action="custom-form"]');

  try {
    if (actionButton) {
      const teamId = actionButton.dataset.teamId;
      const action = actionButton.dataset.action;

      if (action === 'adjust') {
        await postJson('update', teamId, {
          amount: Number(actionButton.dataset.amount)
        });
      }

      if (action === 'reset-team') {
        await postJson('reset-team', teamId);
      }

      renderAdmin(currentData);
      setStatus(`Saved at ${formatUpdatedAt(currentData.updatedAt)}`);
      return;
    }

    if (event.target.id === 'open-viewer-button') {
      window.open('./viewer.php', '_blank', 'noopener');
      return;
    }

    if (event.target.id === 'reset-all-button') {
      await postJson('reset-all');
      renderAdmin(currentData);
      setStatus(`All teams reset at ${formatUpdatedAt(currentData.updatedAt)}`);
      return;
    }

    if (form && event.type === 'submit') {
      event.preventDefault();
      const teamId = form.dataset.teamId;
      const formData = new FormData(form);
      const amount = Number(formData.get('customAmount'));
      if (!Number.isFinite(amount) || amount === 0) {
        setStatus('Enter a positive or negative number before clicking Apply.');
        return;
      }

      await postJson('update', teamId, { amount });
      renderAdmin(currentData);
      setStatus(`Custom score saved at ${formatUpdatedAt(currentData.updatedAt)}`);
    }
  } catch (error) {
    setStatus(error.message);
  }
}

async function init() {
  const pageType = document.body.dataset.pageType;
  await refreshPage(pageType);

  if (pageType === 'admin') {
    document.addEventListener('click', handleAdminAction);
    document.addEventListener('submit', handleAdminAction);
  }

  setInterval(async () => {
    try {
      await refreshPage(pageType);
      if (pageType === 'admin') {
        setStatus(`Synced at ${formatUpdatedAt(currentData.updatedAt)}`);
      }
    } catch {
      if (pageType === 'admin') {
        setStatus('Unable to refresh scores right now.');
      }
    }
  }, pollIntervalMs);
}

init().catch((error) => {
  const app = document.querySelector('#app');
  app.innerHTML = `<div class="page-shell"><p>${error.message}</p></div>`;
});
