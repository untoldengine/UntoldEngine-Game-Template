//
//  AppDelegate.swift
//  Game-Template
//
//  Created by Harold Serrano on 12/21/24.
//

import Cocoa
import UntoldEngine
import MetalKit

class GameScene {
    
    // Declare entity IDs for the red player and ball
    let redPlayer: EntityID
    let ball: EntityID
    var startMoving: Bool = false // Tracks if the player is moving
    
    init() {
        
        // Step 1: Configure the Camera
        camera.lookAt(
            eye: simd_float3(0.0, 7.0, 15.0), // Camera position
            target: simd_float3(0.0, 0.0, 0.0), // Look-at target
            up: simd_float3(0.0, 1.0, 0.0) // Up direction
        )
        
        // Step 2: Create a Stadium Entity
        let stadium = createEntity()
        setEntityMesh(entityId: stadium, filename: "stadium", withExtension: "usdc")
        
        // Step 3: Create a Red Player Entity with Animation
        redPlayer = createEntity()
        setEntityMesh(entityId: redPlayer, filename: "redshirtplayer", withExtension: "usdc", flip: false)
        
        // Load animations for the red player
        setEntityAnimations(entityId: redPlayer, filename: "runninganim", withExtension: "usdc", name: "running")
        setEntityAnimations(entityId: redPlayer, filename: "idleanim", withExtension: "usdc", name: "idle")
        
        // Start with the idle animation
        changeAnimation(entityId: redPlayer, name: "idle")
        
        // Enable physics for the red player
        setEntityKinetics(entityId: redPlayer)
        
        // Step 4: Create a Ball Entity
        ball = createEntity()
        setEntityMesh(entityId: ball, filename: "ball", withExtension: "usdc")
        
        // Position the ball above the ground
        translateBy(entityId: ball, position: simd_float3(0.0, 0.6, 1.0))
        
        // Step 5: Assign the Ball as a Child of the Player
        setParent(childId: ball, parentId: redPlayer)
        
        // Step 6: Create a Sun Entity for Directional Lighting
        let sunEntity: EntityID = createEntity()
        
        // Create the directional light instance
        let sun: DirectionalLight = DirectionalLight()
        
        // Add the light to the lighting system
        lightingSystem.addDirectionalLight(entityID: sunEntity, light: sun)
    }
    
    func update(deltaTime: Float) {
        
        // Skip logic if not in game mode
        if gameMode == false {
            return
        }
        
        // Handle idle animation and physics pause
        if !startMoving {
            changeAnimation(entityId: redPlayer, name: "idle")
            pausePhysicsComponent(entityId: redPlayer, isPaused: true)
            return
        } else {
            changeAnimation(entityId: redPlayer, name: "running")
            pausePhysicsComponent(entityId: redPlayer, isPaused: false)
        }
        
        // Compute new position based on input
        var newPosition = getPosition(entityId: redPlayer)
        
        if inputSystem.keyState.wPressed {
            newPosition.z += 1.0
        }
        
        if inputSystem.keyState.sPressed {
            newPosition.z -= 1.0
        }
        
        if inputSystem.keyState.aPressed {
            newPosition.x -= 1.0
        }
        
        if inputSystem.keyState.dPressed {
            newPosition.x += 1.0
        }
        
        // Steer the player to the new position
        steerTo(entityId: redPlayer, targetPosition: newPosition, maxSpeed: 2.0, deltaTime: deltaTime, turnSpeed: 5.0)
        
        // Rotate the ball around its local right axis
        rotateBy(entityId: ball, angle: 5.0, axis: getRightAxisVector(entityId: ball))
    }
    
    func handleInput() {
        
        // Skip logic if not in game mode
        if gameMode == false {
            return
        }
        
        // Update the startMoving flag based on input
        if inputSystem.keyState.aPressed == false &&
            inputSystem.keyState.wPressed == false &&
            inputSystem.keyState.sPressed == false &&
            inputSystem.keyState.dPressed == false {
            startMoving = false
        } else {
            startMoving = true
        }
    }
}


@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var renderer: UntoldRenderer!
    var gameScene: GameScene!

    func applicationDidFinishLaunching(_: Notification) {
        print("Launching Untold Engine v0.2")

        // Step 1: Create and configure the window
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1280, height: 720),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Untold Engine v0.2"
        window.center()

        // Step 2: Initialize the renderer
        guard let renderer = UntoldRenderer.create() else {
            print("Failed to initialize the renderer.")
            return
        }
        window.contentView = renderer.metalView
        self.renderer = renderer
        renderer.initResources()

        // Step 3: Create the game scene and connect callbacks
        gameScene = GameScene()
        renderer.setupCallbacks(
            gameUpdate: { [weak self] deltaTime in self?.gameScene.update(deltaTime: deltaTime) },
            handleInput: { [weak self] in self?.gameScene.handleInput() }
        )

        window.makeKeyAndOrderFront(nil)
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        return true
    }
    
    func applicationWillTerminate(_: Notification) {
        // Cleanup logic here
    }
}
