---
name: understand-dashboard
description: Launch the interactive web dashboard to visualize a codebase's knowledge graph
argument-hint: "[project-path]"
---

# Launch Interactive Dashboard

This command automatically detects your shell and launches the understand-anything dashboard with the knowledge graph.

## Prerequisites

1. **Knowledge graph exists**: Run `/understand` first if not already done
2. **Port 5173 available**: Make sure nothing else is using this port
3. **Keep terminal open**: The dashboard requires an active Vite development server

## How It Works

This command will:

1. **Auto-detect your shell** (PowerShell, Xonsh, or Bash)
2. **Locate the knowledge graph** at `~/.understand-anything/` or custom project path
3. **Set up environment** with `GRAPH_DIR` pointing to your project
4. **Start Vite dev server** on `127.0.0.1:5173`
5. **Generate secure token** for authenticated access
6. **Display dashboard URL** with token for you to open in browser

## Shell Detection & Setup

The following instructions are shell-specific:

### For PowerShell Core (pwsh) or PowerShell

```powershell
# 1. Set the graph directory (resolves ~ to your user profile)
$env:GRAPH_DIR = "$env:USERPROFILE\.local\share\chezmoi"

# 2. Navigate to dashboard
cd "$env:USERPROFILE\.understand-anything-plugin\packages\dashboard"

# 3. Start the Vite dev server
npx vite --host 127.0.0.1
```

**Watch for this output:**
```
🔑  Dashboard URL: http://127.0.0.1:5173/?token=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

Copy and paste the full URL into your browser.

---

### For Xonsh or Bash

```bash
# 1. Set the graph directory (~ auto-expands to $HOME)
export GRAPH_DIR="~/.local/share/chezmoi"

# 2. Navigate to dashboard
cd ~/.understand-anything-plugin/packages/dashboard

# 3. Start the Vite dev server
npx vite --host 127.0.0.1
```

**Watch for this output:**
```
🔑  Dashboard URL: http://127.0.0.1:5173/?token=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

Copy and paste the full URL into your browser.

---

## Using a Custom Project Path

If your project is in a different location, specify the path:

### PowerShell

```powershell
$env:GRAPH_DIR = "C:\path\to\your\project"
# Then follow the steps above
```

### Xonsh/Bash

```bash
export GRAPH_DIR="/path/to/your/project"
# Or with ~ expansion:
export GRAPH_DIR="~/your/project/path"
# Then follow the steps above
```

---

## Dashboard Features

Once the dashboard loads, you can:

- **Explore the graph**: Drag nodes, scroll to zoom, click for details
- **Search**: Find specific files or configurations
- **Filter**: By layer, type, or tags
- **Learn**: Start the 12-step guided tour
- **Inspect**: View node relationships and dependencies
- **Share**: Copy the URL to share with team members

---

## Troubleshooting

### "Connection Refused" Error

**Problem**: `ERR_CONNECTION_REFUSED` when opening the URL

**Solution**:
1. Check that the Vite server is still running in your terminal
2. Look for the "🔑 Dashboard URL" message in the console output
3. Make sure you're using the complete URL with the token parameter
4. Try copying the URL directly from the terminal output

### Server Stops When Terminal Closes

**This is expected behavior** - the Vite development server runs in your terminal session.

**If you close the terminal**:
1. The server stops and dashboard becomes inaccessible
2. You'll need to restart by running the command again
3. A new token will be generated (old token becomes invalid)

### Port 5173 Already in Use

**Problem**: "Port 5173 is in use"

**Solution**:
1. Check what process is using port 5173:
   - PowerShell: `netstat -ano | Select-String "5173"`
   - Bash/Xonsh: `netstat -ano | grep 5173`
2. Close that process or use a different port by modifying the command:
   ```bash
   # Change 5173 to another port (e.g., 5174)
   npx vite --host 127.0.0.1 --port 5174
   ```

### Knowledge Graph Not Found

**Problem**: "No knowledge graph found. Run /understand first."

**Solution**:
1. Run `/understand` to generate the knowledge graph
2. Verify `knowledge-graph.json` exists:
   - PowerShell: `Test-Path "$env:USERPROFILE\.local\share\chezmoi\.understand-anything\knowledge-graph.json"`
   - Bash/Xonsh: `test -f ~/.local/share/chezmoi/.understand-anything/knowledge-graph.json`
3. Check that `GRAPH_DIR` is set to the correct project path

### Dashboard Loads but Shows Blank/Errors

**Problem**: Dashboard shows loading spinner or errors

**Solution**:
1. Check browser console for errors (F12 → Console)
2. Verify the token in the URL matches what's in the terminal
3. Make sure you're using `http://` (not `https://`)
4. Try clearing browser cache or using an incognito/private window
5. Restart the server: Close terminal and run the command again

---

## Important Notes

### Session Management

⚠️ **Keep your terminal open** while using the dashboard

- The Vite development server must stay running
- Closing the terminal stops the server
- If the connection drops, you'll see "Connection Refused"
- Simply restart the server by running the command again

### Token Security

🔐 **Each server session gets a unique token**

- Token is generated randomly when Vite starts
- Token is required to access the dashboard data
- Token is NOT persisted - a new one is created on each restart
- URL includes token in query parameter: `?token=...`

### Sharing the Dashboard

When sharing with team members:

1. Keep your server running
2. Share the full URL (including token)
3. They can access the dashboard from their browser
4. Works best on your local network or with VPN
5. Note: Server only accepts connections from `127.0.0.1` by default (localhost only)

---

## Advanced: Custom Configuration

### Modifying Vite Server Options

Edit the Vite startup command:

```bash
# Different host (warning: opens to all IPs)
npx vite --host 0.0.0.0

# Different port
npx vite --host 127.0.0.1 --port 5174

# With custom token
export UNDERSTAND_ACCESS_TOKEN="my-custom-token"
npx vite --host 127.0.0.1
```

### Analyzing Multiple Projects

To view a different project's knowledge graph:

1. Change `GRAPH_DIR` to point to that project:
   ```bash
   export GRAPH_DIR="/path/to/other/project"
   ```
2. Keep the rest of the setup the same
3. Restart the server for the change to take effect

---

## Next Steps

1. **Run the appropriate commands above** based on your shell
2. **Wait for Vite to start** (usually takes 2-3 seconds)
3. **Copy the dashboard URL** from the terminal output
4. **Open in browser** and start exploring!
5. **Keep terminal open** while using the dashboard
