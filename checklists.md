# 🚀 Kai's Genesis - Complete Development Roadmap

## Phase 1: The "First Time User Experience" (FTUE)

**Focus:** The crucial first 5 minutes. Hook the player with story, identity, and teaching.

### 1.1. The Boot Sequence & Cinematic

* [x] **Splash Screen:** Godot logo / Studio Logo -> "Kai's Genesis" Title Screen.
* [ ] **The "Awakening" Cinematic:**
* *Concept:* A "Beerus-like" awakening. A bubble bursts in the void.
* *Visuals:* A series of pixel-art stills or simple animations showing Kai waking up, yawning, and casually destroying a nearby planet with a tap.
* *Transition:* The camera pans away from the destruction to a small, empty floating rock (The Player's Station).



### 1.2. Character Creation (The Apprentice)

* [ ] **The "Apprentice" Interface:**
* *Prompt:* "Kai needs a new caretaker for the next cycle."
* *Selection:* Choose Avatar Style (Male / Female / Neutral / Robot).
* *Naming:* Input field for "Apprentice Name".


* [ ] **Data Commit:** Create the `savegame.json` immediately here to store their Name/Avatar.

### 1.3. The Orientation (Interactive Tutorial)

* [ ] **The Empty Void:** Player starts with *only* 1 tile and the "Hand" tool.
* [ ] **Step 1 - Expansion:** Dialogue box: *"This rock is too small. Expand it."* (Forces player to buy/place 3 Earth tiles).
* [ ] **Step 2 - Life:** *"It is dead. Bring it life."* (Forces player to buy/place a Chick).
* [ ] **Step 3 - The Warning:** *"Do not fail me. If this world dies, I will erase it."* (Explains the Game Over condition).

---

## Phase 2: Persistence & Interface (The "Web Ready" Update)

**Focus:** Now that they have a character and a world, ensure they can keep it.

### 2.1. Save System (High Priority)

* [ ] **Web-Safe Implementation:** Use `FileAccess` to save the world state + The Apprentice Data (Name/Avatar).
* [ ] **Auto-Save:** Trigger a save every time the player buys land or finishes the tutorial.
* [ ] **Visual Indicator:** A small "Floppy Disk" or "Orbiting Icon" in the corner when saving.

### 2.2. UI Overhaul (The "Cockpit")

* [ ] **The HUD:** Implement the new "Dark Space" aesthetic.
* *Avatar Display:* Show the Apprentice face chosen in Phase 1 in the top corner.
* *Toolbox:* Permanent bar for Hand, Land, Fence, Axe.


* [ ] **The Shop:** Slide-out panel for buying items, ensuring it doesn't block the view of the world.

---

## Phase 3: The "Juice" & Atmosphere

**Focus:** Making the loop feel responsive and immersive.

### 3.1. Audio-Visual Feedback

* [ ] **Sound Effects:**
* *UI:* "Bloop" for text scrolling in the tutorial. "Click" for buttons.
* *World:* "Thump" for placing land. "Moo/Chirp" when clicking animals.


* [ ] **Visuals:**
* *Particles:* Dust cloud when placing land. Sparkles when collecting Life Force.
* *Rain Shader:* (You have this!) Ensure it toggles correctly.



### 3.2. Atmospheric Backgrounds

* [ ] **Dynamic Background:** Add the animated planets in the distance.
* [ ] **The Looming Threat:** Occasionally show Kai's silhouette in the background to remind the player who is boss.

---

## Phase 4: Gameplay Depth (The "God" Mechanics)

**Focus:** Moving from simple clicking to ecosystem management.

### 4.1. Interactive Tools

* [ ] **The God Lift:** Tool to hover/move animals to organize the farm.
* [ ] **The Shield:** Paid active ability to block damage.

### 4.2. Natural Disasters (The Threat)

* [ ] **Space Storms:** Random events that damage tiles.
* [ ] **The "Kai Check-in":** Random events where Kai "inspects" the world. If Life Force is too low, he destroys a chunk of land.

---

## Phase 5: "Moonshot" Expansion

**Focus:** Long-term growth.

* [ ] **3D Globe Expansion:** Wrapping the 2D plane onto a sphere.
* [ ] **Multiple Worlds:** "Prestige" by destroying the current world to feed Kai, then starting a fresh one with permanent multipliers.
* [ ] **Cloud Saves:** Cross-device play.