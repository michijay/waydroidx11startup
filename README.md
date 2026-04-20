# Waydroid X11 Manager

A lightweight Bash utility to manage Waydroid sessions on X11 desktops (like Cinnamon) using Weston as a nested compositor. This script handles container lifecycle, session initialization, and clean termination.

## Version
1.0-0

## Prerequisites

- **Waydroid**: Installed and initialized (`sudo waydroid init`).
- **Weston**: Required as the nested Wayland compositor.
- **NVIDIA Drivers**: The script includes a fix for cursor visibility on NVIDIA hardware.
- **Debian/Ubuntu base**: Tested on Debian Workstation.

## Installation

1. Clone the repository:
   ```bash
   git clone [https://github.com/VaMaToX/waydroidx11startup.git](https://github.com/VaMaToX/waydroidx11startup.git)
   cd waydroidx11startup
   ```
2. Make the script executable:
   ```bash
   chmod +x waydroid-launcher.sh
   ```
 ##  Features

    Auto-Check: Verifies if the waydroid-container service is running.

    Interactive: Asks for sudo permissions only when necessary.

    NVIDIA Optimized: Forces software cursors to prevent invisibility issues on NVIDIA/X11.

    Clean Exit: Automatically stops the Waydroid session and optionally the container service when closing the window.

## License and credits

Author: Michael Janssen (m.janssen@lyrah.net)

License: This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License Version 3 as published by the Free Software Foundation.
