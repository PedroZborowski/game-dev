🇧🇷 [Versão em Português](README.pt-BR.md)

# Escape the Purple House

<details>
  <summary>
    <strong>Warning: the image below contains in-game footage. Due to its horror theme, even without graphic content, it may be unsettling for some people.</strong>
    <br>
    <em>Click to reveal.</em>
  </summary>

  ![Screenshot of Escape the Purple House](https://github.com/PedroZborowski/game-dev/blob/main/escape-the-purple-house/imagemresumo.png?raw=true)

</details>

## About the Project

This is my very first game — the project that marked my entry into game development. Built in 2022, it was a particularly challenging endeavor because it was developed before LLMs (like ChatGPT) became widely accessible. That meant every problem had to be solved the hard way: through documentation, forums, and a lot of experimentation.

It was also entirely self-taught, built before I started university, driven purely by a passion for games and a curiosity about how they actually work.

## The Core Challenge: Monster AI

Despite the game's overall simplicity, my main focus and area of study was the enemy AI — the monster that hunts the player. Rather than a simple, predictable behavior, I dedicated significant time to researching and implementing different algorithms to make the pursuit feel genuinely challenging and immersive.

> **The full AI source code, written in Lua, is available in [`AI.lua`](./AI.lua) in this repository.**

The AI development covered:

- **State Machines:** Controlling the monster's distinct behaviors — `PATROLLING`, `CHASING`, and `ATTACKING`.
- **Player Detection:** Logic for the monster to "sense" the player's presence through a field-of-view system.
- **Pathfinding Algorithms:** Enabling the monster to navigate the environment intelligently, routing around obstacles to reach the player.

## Tech Stack

- **Engine:** Roblox Studio
- **Language:** Lua

## Key Takeaways

- Designing and implementing enemy AI systems from scratch.
- Managing game states (menu, gameplay, game over).
- Independent problem-solving using documentation and forums as the primary knowledge source.
- Structuring a full game project from concept to a playable product.

## Play It

The game is live on Roblox:
https://www.roblox.com/games/10003574475/Escape-from-the-Purple-House
