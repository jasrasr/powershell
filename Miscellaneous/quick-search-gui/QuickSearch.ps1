[CmdletBinding()]
param(
    [string[]]$Roots,
    [switch]$SelfTest
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not ('QuickSearch.SearchEngine' -as [type])) {
    Add-Type -Language CSharp -TypeDefinition @'
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace QuickSearch
{
    public sealed class SearchResult
    {
        public string Name { get; set; }
        public string Directory { get; set; }
        public string FullPath { get; set; }
        public string Type { get; set; }
        public bool IsDirectory { get; set; }
    }

    public sealed class SearchEngine : IDisposable
    {
        private readonly ConcurrentDictionary<string, byte> paths =
            new ConcurrentDictionary<string, byte>(StringComparer.OrdinalIgnoreCase);
        private readonly List<FileSystemWatcher> watchers = new List<FileSystemWatcher>();
        private CancellationTokenSource cancellation;
        private int scanning;

        public int Count { get { return paths.Count; } }
        public bool IsScanning { get { return Volatile.Read(ref scanning) != 0; } }

        public Task BuildAsync(IEnumerable<string> roots)
        {
            Stop();
            cancellation = new CancellationTokenSource();
            CancellationToken token = cancellation.Token;
            string[] selected = roots.Where(Directory.Exists).Distinct(StringComparer.OrdinalIgnoreCase).ToArray();
            Interlocked.Exchange(ref scanning, 1);

            return Task.Run(() =>
            {
                try
                {
                    Parallel.ForEach(selected, new ParallelOptions { CancellationToken = token }, root =>
                    {
                        IndexRoot(root, token);
                        AddWatcher(root);
                    });
                }
                catch (OperationCanceledException) { }
                finally { Interlocked.Exchange(ref scanning, 0); }
            }, token);
        }

        private void IndexRoot(string root, CancellationToken token)
        {
            var pending = new Stack<string>();
            pending.Push(root);
            while (pending.Count > 0)
            {
                token.ThrowIfCancellationRequested();
                string current = pending.Pop();
                paths.TryAdd(current, 0);
                try
                {
                    foreach (string entry in Directory.EnumerateFileSystemEntries(current))
                    {
                        token.ThrowIfCancellationRequested();
                        paths.TryAdd(entry, 0);
                        try
                        {
                            if ((File.GetAttributes(entry) & FileAttributes.Directory) != 0)
                                pending.Push(entry);
                        }
                        catch (UnauthorizedAccessException) { }
                        catch (IOException) { }
                    }
                }
                catch (UnauthorizedAccessException) { }
                catch (DirectoryNotFoundException) { }
                catch (IOException) { }
            }
        }

        private void AddWatcher(string root)
        {
            try
            {
                var watcher = new FileSystemWatcher(root);
                watcher.IncludeSubdirectories = true;
                watcher.NotifyFilter = NotifyFilters.FileName | NotifyFilters.DirectoryName;
                watcher.Created += (s, e) => paths.TryAdd(e.FullPath, 0);
                watcher.Deleted += (s, e) => { byte ignored; paths.TryRemove(e.FullPath, out ignored); };
                watcher.Renamed += (s, e) =>
                {
                    byte ignored;
                    paths.TryRemove(e.OldFullPath, out ignored);
                    paths.TryAdd(e.FullPath, 0);
                };
                watcher.EnableRaisingEvents = true;
                lock (watchers) watchers.Add(watcher);
            }
            catch (ArgumentException) { }
            catch (IOException) { }
            catch (UnauthorizedAccessException) { }
        }

        public SearchResult[] Search(string query, int limit)
        {
            if (String.IsNullOrWhiteSpace(query) || limit < 1) return new SearchResult[0];
            string[] terms = query.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            var matches = new List<SearchResult>(Math.Min(limit, 256));

            foreach (string path in paths.Keys)
            {
                bool match = true;
                foreach (string term in terms)
                {
                    if (path.IndexOf(term, StringComparison.OrdinalIgnoreCase) < 0)
                    { match = false; break; }
                }
                if (!match) continue;

                string name = Path.GetFileName(path);
                if (String.IsNullOrEmpty(name)) name = path;
                bool isDirectory = DirectoryExists(path);
                string extension = isDirectory ? String.Empty : Path.GetExtension(name);
                matches.Add(new SearchResult
                {
                    Name = name,
                    Directory = Path.GetDirectoryName(path) ?? String.Empty,
                    FullPath = path,
                    Type = isDirectory ? "Folder" :
                        (String.IsNullOrEmpty(extension) ? "File" : extension.TrimStart('.').ToUpperInvariant() + " file"),
                    IsDirectory = isDirectory
                });
                if (matches.Count >= limit) break;
            }

            return matches
                .OrderBy(r => r.Name.StartsWith(terms[0], StringComparison.OrdinalIgnoreCase) ? 0 : 1)
                .ThenBy(r => r.Name.Length)
                .ThenBy(r => r.Name, StringComparer.OrdinalIgnoreCase)
                .ToArray();
        }

        private static bool DirectoryExists(string path)
        {
            try { return Directory.Exists(path); }
            catch { return false; }
        }

        public void Stop()
        {
            if (cancellation != null) cancellation.Cancel();
            lock (watchers)
            {
                foreach (var watcher in watchers) watcher.Dispose();
                watchers.Clear();
            }
        }

        public void Dispose()
        {
            Stop();
            if (cancellation != null) cancellation.Dispose();
        }
    }
}
'@
}

if ($SelfTest) {
    $testRoot = Join-Path ([IO.Path]::GetTempPath()) ('QuickSearch-' + [guid]::NewGuid())
    $engine = $null
    try {
        $null = New-Item -ItemType Directory -Path (Join-Path $testRoot 'Reports') -Force
        $null = New-Item -ItemType File -Path (Join-Path $testRoot 'Reports\Quarterly-Widget.txt')
        $engine = [QuickSearch.SearchEngine]::new()
        $task = $engine.BuildAsync([string[]]@($testRoot))
        if (-not $task.Wait(10000)) { throw 'Index build timed out.' }
        $matches = $engine.Search('quarter widget', 20)
        if ($matches.Count -ne 1 -or $matches[0].Name -ne 'Quarterly-Widget.txt' -or $matches[0].Type -ne 'TXT file') {
            throw 'Search engine did not return the expected result.'
        }
        "PASS: indexed $($engine.Count) entries and found $($matches[0].FullPath)"
    }
    finally {
        if ($null -ne $engine) { $engine.Dispose() }
        Remove-Item -LiteralPath $testRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
    exit 0
}

if ([Threading.Thread]::CurrentThread.ApartmentState -ne 'STA') {
    throw 'Quick Search requires STA mode. Start it with: powershell.exe -STA -File .\QuickSearch.ps1'
}

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Quick Search" Height="620" Width="980" MinHeight="420" MinWidth="680"
        WindowStartupLocation="CenterScreen" Background="#111827" Foreground="#F9FAFB">
  <Grid Margin="18">
    <Grid.RowDefinitions>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="*"/>
      <RowDefinition Height="Auto"/>
    </Grid.RowDefinitions>
    <TextBox Name="SearchBox" Height="46" FontSize="20" Padding="12,8"
             Background="#1F2937" Foreground="White" BorderBrush="#4B5563"
             ToolTip="Type part of a file or folder name"/>
    <TextBlock Name="HintText" Grid.Row="1" Margin="2,8,2,8" Foreground="#9CA3AF"
               Text="Building the index in the background… you can search immediately."/>
    <ListView Name="Results" Grid.Row="2" Background="#111827" Foreground="#F9FAFB"
              BorderBrush="#374151" ScrollViewer.IsDeferredScrollingEnabled="True"
              VirtualizingPanel.IsVirtualizing="True" VirtualizingPanel.VirtualizationMode="Recycling">
      <ListView.Resources>
        <SolidColorBrush x:Key="{x:Static SystemColors.HighlightBrushKey}" Color="#2563EB"/>
        <SolidColorBrush x:Key="{x:Static SystemColors.InactiveSelectionHighlightBrushKey}" Color="#1D4ED8"/>
        <SolidColorBrush x:Key="{x:Static SystemColors.HighlightTextBrushKey}" Color="#FFFFFF"/>
        <SolidColorBrush x:Key="{x:Static SystemColors.InactiveSelectionHighlightTextBrushKey}" Color="#FFFFFF"/>
      </ListView.Resources>
      <ListView.ItemContainerStyle>
        <Style TargetType="ListViewItem">
          <Setter Property="Foreground" Value="#F9FAFB"/>
          <Setter Property="Background" Value="Transparent"/>
          <Setter Property="Padding" Value="2"/>
          <Style.Triggers>
            <Trigger Property="IsSelected" Value="True">
              <Setter Property="Background" Value="#2563EB"/>
              <Setter Property="Foreground" Value="#FFFFFF"/>
            </Trigger>
          </Style.Triggers>
        </Style>
      </ListView.ItemContainerStyle>
      <ListView.View>
        <GridView>
          <GridViewColumn Header="Name" Width="300" DisplayMemberBinding="{Binding Name}"/>
          <GridViewColumn Header="Type" Width="100" DisplayMemberBinding="{Binding Type}"/>
          <GridViewColumn Header="Folder" Width="500" DisplayMemberBinding="{Binding Directory}"/>
        </GridView>
      </ListView.View>
    </ListView>
    <TextBlock Grid.Row="3" Margin="2,10,2,0" Foreground="#9CA3AF"
               Text="Enter: open    Ctrl+Enter: containing folder    Esc: clear"/>
  </Grid>
</Window>
'@

$reader = [System.Xml.XmlNodeReader]::new($xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
$searchBox = $window.FindName('SearchBox')
$results = $window.FindName('Results')
$hintText = $window.FindName('HintText')
$engine = [QuickSearch.SearchEngine]::new()

if (-not $Roots -or $Roots.Count -eq 0) {
    $Roots = [IO.DriveInfo]::GetDrives() |
        Where-Object { $_.DriveType -eq 'Fixed' -and $_.IsReady } |
        ForEach-Object RootDirectory |
        ForEach-Object FullName
}

$null = $engine.BuildAsync($Roots)
$searchTimer = [Windows.Threading.DispatcherTimer]::new()
$searchTimer.Interval = [TimeSpan]::FromMilliseconds(80)
$statusTimer = [Windows.Threading.DispatcherTimer]::new()
$statusTimer.Interval = [TimeSpan]::FromMilliseconds(500)

$runSearch = {
    $searchTimer.Stop()
    $query = $searchBox.Text
    if ([string]::IsNullOrWhiteSpace($query)) {
        $results.ItemsSource = $null
        return
    }
    $started = [Diagnostics.Stopwatch]::StartNew()
    $found = $engine.Search($query, 300)
    $started.Stop()
    $results.ItemsSource = $found
    $hintText.Text = "Found $($found.Count) shown in $($started.ElapsedMilliseconds) ms | $($engine.Count.ToString('N0')) indexed"
}

$searchTimer.Add_Tick($runSearch)
$searchBox.Add_TextChanged({ $searchTimer.Stop(); $searchTimer.Start() })
$statusTimer.Add_Tick({
    if ($engine.IsScanning) {
        $hintText.Text = "Indexing… $($engine.Count.ToString('N0')) files and folders ready"
    } elseif ([string]::IsNullOrWhiteSpace($searchBox.Text)) {
        $hintText.Text = "Ready | $($engine.Count.ToString('N0')) files and folders indexed"
    }
})

$openSelected = {
    param([bool]$ContainingFolder)
    $item = $results.SelectedItem
    if ($null -eq $item) { return }
    if ($ContainingFolder -and -not $item.IsDirectory) {
        Start-Process explorer.exe -ArgumentList "/select,`"$($item.FullPath)`""
    } elseif ($ContainingFolder) {
        Start-Process explorer.exe -ArgumentList $item.FullPath
    } else {
        Start-Process -FilePath $item.FullPath
    }
}

$results.Add_MouseDoubleClick({ & $openSelected $false })
$window.Add_KeyDown({
    param($sender, $eventArgs)
    if ($eventArgs.Key -eq [Windows.Input.Key]::Escape) {
        $searchBox.Clear(); $searchBox.Focus(); $eventArgs.Handled = $true
    } elseif ($eventArgs.Key -eq [Windows.Input.Key]::Enter) {
        & $openSelected ([Windows.Input.Keyboard]::Modifiers -band [Windows.Input.ModifierKeys]::Control)
        $eventArgs.Handled = $true
    } elseif ($eventArgs.Key -eq [Windows.Input.Key]::Down -and $searchBox.IsKeyboardFocused -and $results.Items.Count -gt 0) {
        $results.SelectedIndex = 0; $results.Focus(); $eventArgs.Handled = $true
    }
})

$window.Add_ContentRendered({ $searchBox.Focus(); $statusTimer.Start() })
$window.Add_Closed({ $searchTimer.Stop(); $statusTimer.Stop(); $engine.Dispose() })
$null = $window.ShowDialog()
