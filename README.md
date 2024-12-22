# Untold Engine macOS Game Template

This template demonstrates how to create a simple macOS game using the [Untold Engine](https://github.com/untoldengine/UntoldEngine). The scene includes a stadium, a player, and a ball, showcasing the use of the rendering, animation, and physics systems.

If you want to create your own project, follow these [steps](https://github.com/untoldengine/UntoldEngine/blob/master/docs/CreateMacOSGame.md)

[gamescreenshot](images/gamescreenshot.png)

## Features Demonstrated

- Rendering static and animated models.
- Adding physics to entities.
- Using hierarchical relationships (parent-child entities).
- Simple steering and input handling.

## How It Works

1. Stadium: A static entity rendered in the center of the scene.
2. Player: An animated character that starts idle and transitions to running when moved.
3. Ball: A dynamic entity that is set as a child of the player, rotating as the player moves.
4. Camera: Positioned to view the scene from a fixed perspective.
5. Lighting: A directional light simulates sunlight for the scene.

## Controls

- W: Move forward.
- S: Move backward.
- A: Move left.
- D: Move right.
- P: Toggle between Edit and Game modes.

## Getting Started

1. Clone the template
2. Open the project in Xcode
3. Update the Untold Engine Package Dependency:
	- In Xcode, navigate to File → Swift Packages → Update to Latest Package Versions.
	- This ensures you’re using the latest version of the Untold Engine with the most up-to-date features and fixes.
4. Run the project:
	- Press Cmd+R to build and run.
	- Press "p" to enter game mode
	- Use the controls above to interact with the scene.

## What You’ll See

- The player starts idle.
- Pressing movement keys transitions the player to running, with the ball following and rotating.

## Next Steps

- Replace the models with your own .usdc assets. See this guide to [import assets for your game](https://github.com/untoldengine/UntoldEngine/blob/master/docs/ImportingAssetFiles.md)
- Customize animations, physics, and interactions to build your game.
- Explore the Untold Engine Documentation for more advanced features.


## Support

- If you encounter issues, feel free to [open an issue](https://github.com/untoldengine/UntoldEngine/issues)