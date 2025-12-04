# Kai's Genesis - Development Roadmap

## Phase 1: Core Gameplay Loop

**Focus:** Implementing the core mechanics of world expansion and resource management.

### Key Point 1: Dynamic World & Economy
- [ ] **The "Buy Land" Mechanic:**
    - Create `expand_land()` function to change TileMap cells from "Void/Empty" to "Earth".
    - Implement a click-to-buy tool for individual tiles or an "Expand Border" button.
    - Scale land prices based on the number of currently owned tiles.
- [ ] **The Space-Economy Link:**
    - Calculate max Life Force: `max_life_force = base_cap + (land_tiles_count * 100)`.
    - Enforce the cap on the player's current Life Force.
    - Update the UI to display current vs. max Life Force (e.g., "64 / 100"), with a visual indicator when capped.
    - The core loop: Start on a small island, hit the cap, and be forced to buy land to progress.
    - implement axe that leads to destructing or tearing down buildings
 
### Key Point 2: Animal & Entity Interaction
- [ ] **Animal Behavior & Consequences:**
    - Make cows consume grass tiles they wander over.
    - decide to show animations for animals show 
 
## Phase 2: Persistence & Polish
**Focus:** Saving player progress and adding audio-visual feedback to make the game feel more alive.
 
### Key Point 3: Save System
- [ ] **Data Structure:** Define a dictionary to save game state:
    - Current Money
    - An array of purchased land tile coordinates (Vector2s).
    - An array of placed objects (including type and position).
- [ ] **Save/Load Logic:** Use `FileAccess` to write to and read from `user://savegame.save`.
 
### Key Point 4: Audio-Visual Feedback
- [ ] **Sound Effects:**
    - Add a satisfying "pop" or "collect" sound for clicks.
    - Implement a "thump" or "dirt" sound for placing land tiles.
    - make world explode when life exceeds max life
    - negative life force leads to game over and resetting the game
 
## Phase 5: Long-Term Features & Customization
**Focus:** Adding content and features that extend gameplay and add personality.
 
### Key Point 6: Customization & Aesthetics
- [ ] The "Buy Land" Mechanic
- [ ] Add custom music, bg and assets
- [ ] Add planets in the background and a character who is constantly destroying them.
 
### Key Point 7: Game Expansion
- [ ] Add multiple worlds and progression 
- [ ] Add tutorialization