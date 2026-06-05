🇧🇷 [Versão em Português](README.pt-BR.md)

# Wildlife Tower Defense

_A complex Tower Defense game built in Roblox Studio as a team project, with a focus on networking, data persistence, and advanced AI._

![Tiger animation](https://github.com/PedroZborowski/game-dev/blob/main/wildlife-td/images/tiger.gif?raw=true)
![Inventory screen](https://github.com/PedroZborowski/game-dev/blob/main/wildlife-td/images/inventory.png?raw=true)
![Gameplay screenshot](https://github.com/PedroZborowski/game-dev/blob/main/wildlife-td/images/game.png?raw=true)

## About the Project

Wildlife Tower Defense was my second game project and represents a significant leap in complexity, scope, and collaboration compared to my first. Developed with a larger group on Roblox Studio, it exposed me to real-world multiplayer game development challenges.

The goal was to build a complete Tower Defense experience — multiple enemy and tower types, progression systems, persistent data saving — all running in a live client-server environment.

### Status: Discontinued

Development was eventually discontinued. As the original team of developers shrank over time, the project's ambitious scope became unfeasible to complete on schedule. Despite this, it was an invaluable learning experience about the realities of team development and scope management.

## My Role: Lead Developer

> **Note:** Since the full codebase is extensive, I selected key files associated with my contributions and placed them in the [`codes`](./codes/) folder for focused review.

I served as **Lead Developer (Dev Lead)** on this project. Beyond writing code, my primary responsibility was the technical management of the team — ensuring coherence, quality, and smooth integration across contributions. My responsibilities included:

- **Contribution Management:** Organizing, reviewing (code review), and integrating code from nearly **10 different developers**, requiring a deep understanding of every part of the codebase to ensure new features fit the existing architecture.
- **Code Architecture:** Defining the project's base structure and coding standards, allowing independent systems (AI, UI, data saving, etc.) to coexist without conflicts.
- **Conflict Resolution:** Mediating and resolving code conflicts arising from merging contributions across a large team, maintaining project stability throughout.
- **Direct Development:** Beyond team management, I was also the primary developer for several core gameplay systems, detailed in the section below.

## Technical Challenges

This project was a deep dive into complex software engineering problems:

- **Client-Server Interaction:** Ensuring game logic was secure and synchronized across the server and multiple clients, using Roblox's networking layer (`RemoteEvents` and `RemoteFunctions`).
- **Data Persistence:** Implementing a robust `DataStoreService` system to safely save and load player progression.
- **Applied Linear Algebra:** Using vectors and trajectory calculations for tower targeting, enemy movement, and area-of-effect attacks.
- **Advanced AI:** Building multiple enemy and tower behaviors with target-priority logic and special abilities.

## Tech Stack

- **Platform:** Roblox Studio
- **Language:** Luau
