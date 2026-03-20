// Filename: app.js
// Revision: 1.5
// Description: Frontend logic for CVC Scoreboard. Handles score display,
//              admin controls, polling, team/title renaming, and dynamic grid layout.
//              Shared across all scoreboard instances (root, collide, youth).
// Author: Jason Lamb (with help from Claude)
// Created Date: 2026-03-19
// Modified Date: 2026-03-19
// Changelog
// 1.0 Initial PHP release, converted from Node.js/Express
// 1.1 Fixed API URL paths to use relative query params instead of REST-style paths
// 1.2 Added rename team and update scoreboard title features
// 1.3 Increased admin poll to 10s; skip re-render when an input is focused
// 1.4 Added dynamic viewer grid columns to support variable team counts
// 1.5 Fixed Safari mobile scrolling; score font now scales by viewport height

const quickValues = [1, 3, 5, 10];
const viewerPollIntervalMs = 2000;
const adminPollIntervalMs = 10000;
let currentData = null;

async function fetchScores() {
  const response = await fetch('api.php?action=scores');
  if (!response.ok) {
    throw new Error('Unable to load scores.');
  }
  currentData = await response.json();
  return currentData;
}

async function postJson(url, payload = {}) {
  const response = await fetch(url, {
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

function scoreFontStyle(score) {
  const len = String(Math.abs(score)).length;
  if (len <= 3) return '';
  const vw = len === 4 ? 9 : len === 5 ? 7 : 5;
  return `style="font-size: clamp(1rem, min(${vw}vw, ${vw}vh), 10rem);"`;
}

function createQuickButtons(teamId) {
  return quickValues
    .map((value) => `
      <button class="positive" type="button" data-action="adjust" data-team-id="${teamId}" data-amount="${value}">+${value}</button>
      <button class="negative" type="button" data-action="adjust" data-team-id="${teamId}" data-amount="-${value}">-${value}</button>
    `)
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
        <div class="score-value" ${scoreFontStyle(team.score)}>${team.score}</div>
      </div>
      <div class="button-grid">
        ${createQuickButtons(team.id)}
      </div>
      <form class="custom-controls" data-action="custom-form" data-team-id="${team.id}">
        <input name="customAmount" type="number" inputmode="numeric" step="1" placeholder="Custom +/- amount" aria-label="Custom amount for ${team.name}" />
        <button class="secondary" type="submit">Apply</button>
      </form>
      <form class="custom-controls" data-action="rename-form" data-team-id="${team.id}">
        <input name="teamName" type="text" value="${team.name}" aria-label="Rename ${team.name}" />
        <button class="secondary" type="submit">Rename</button>
      </form>
      <div class="card-footer">
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
        <div class="score-value" ${scoreFontStyle(team.score)}>${team.score}</div>
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
          <form data-action="title-form" style="display:flex;gap:0.5rem;">
            <input name="pageTitle" type="text" value="${data.title}" aria-label="Scoreboard title" />
            <button class="secondary" type="submit">Update Title</button>
          </form>
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
  const teamCount = data.teams.length;
  const cols = teamCount <= 4 ? 2 : teamCount <= 6 ? 3 : 4;
  const rows = Math.ceil(teamCount / cols);
  const gridStyle = `grid-template-columns: repeat(${cols}, minmax(0, 1fr)); grid-template-rows: repeat(${rows}, minmax(0, 1fr));`;

  app.innerHTML = `
    <div class="viewer-page">
      <header class="page-header">
        ${renderSharedHeader(data, 'viewer')}
        <div class="header-actions">
          <div class="updated-at">Auto-refresh every ${viewerPollIntervalMs / 1000} seconds</div>
        </div>
      </header>
      <main class="viewer-grid" style="${gridStyle}">
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
  const form = event.target.closest('form[data-action]');

  try {
    if (actionButton) {
      const teamId = actionButton.dataset.teamId;
      const action = actionButton.dataset.action;

      if (action === 'adjust') {
        await postJson(`api.php?action=update&team=${teamId}`, {
          amount: Number(actionButton.dataset.amount)
        });
      }

      if (action === 'reset-team') {
        await postJson(`api.php?action=reset-team&team=${teamId}`);
      }

      renderAdmin(currentData);
      setStatus(`Saved at ${formatUpdatedAt(currentData.updatedAt)}`);
      return;
    }

    if (event.target.id === 'open-viewer-button') {
      window.open('index.php', '_blank', 'noopener');
      return;
    }

    if (event.target.id === 'reset-all-button') {
      await postJson('api.php?action=reset-all');
      renderAdmin(currentData);
      setStatus(`All teams reset at ${formatUpdatedAt(currentData.updatedAt)}`);
      return;
    }

    if (form && event.type === 'submit') {
      event.preventDefault();
      const teamId = form.dataset.teamId;
      const formData = new FormData(form);

      if (form.dataset.action === 'title-form') {
        const title = formData.get('pageTitle').trim();
        if (!title) {
          setStatus('Title cannot be empty.');
          return;
        }
        await postJson('api.php?action=rename-title', { title });
        renderAdmin(currentData);
        setStatus(`Title updated at ${formatUpdatedAt(currentData.updatedAt)}`);
        return;
      }

      if (form.dataset.action === 'rename-form') {
        const name = formData.get('teamName').trim();
        if (!name) {
          setStatus('Team name cannot be empty.');
          return;
        }
        await postJson(`api.php?action=rename-team&team=${teamId}`, { name });
        renderAdmin(currentData);
        setStatus(`Team renamed at ${formatUpdatedAt(currentData.updatedAt)}`);
        return;
      }

      const amount = Number(formData.get('customAmount'));
      if (!Number.isFinite(amount) || amount === 0) {
        setStatus('Enter a positive or negative number before clicking Apply.');
        return;
      }

      await postJson(`api.php?action=update&team=${teamId}`, { amount });
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

  const pollIntervalMs = pageType === 'viewer' ? viewerPollIntervalMs : adminPollIntervalMs;
  setInterval(async () => {
    try {
      const activeTag = document.activeElement?.tagName;
      const inputFocused = activeTag === 'INPUT' || activeTag === 'TEXTAREA';

      if (pageType === 'admin' && inputFocused) {
        return;
      }

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
