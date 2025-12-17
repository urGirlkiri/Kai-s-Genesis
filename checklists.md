# Kai's Genesis - Development Roadmap


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
 
## Phase 5: Long-Term Features & Customization
**Focus:** Adding content and features that extend gameplay and add personality.
 
### Key Point 6: Customization & Aesthetics
- [ ] Add custom music, bg and assets
- [ ] Add planets in the background and a character who is constantly destroying them.
 
### Key Point 7: Game Expansion
- [ ] Make the plane exapandable into a 3d globe like world
- [ ] Add multiple worlds and progression 
- [ ] Add tutorialization
- [ ] when world expands add the kai eye at the top or bottom where one can see the prt of the map they at
- [ ] Add a powerup god lift to lift off animals off the plane
- [ ] Add natural disaster like space storms and a corresponding powerup  to shield the plane
