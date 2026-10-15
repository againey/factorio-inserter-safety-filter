# Inserter Safety Filter

This is a *Factorio* mod that automatically adds an empty filter to an inserter when first placed if that inserter's drop location will instantly destroy items.

## Overview

Ever lost your quality thrusters to deep space because an unfiltered inserter decided to toss everything out of the space platform hub? Ever chucked all of your legendary tungsten into the lava for a similar reason?

This mod will help protect you from simple mistakes like this. Every time you place an inserter that drops its items to a destructive tile like empty space or lava, the inserter will instantly receive a filter that accepts no item type. You can then disable the filtering option or specify specific items to filter once you are ready for the inserter to do its work.

## Features

- Automatically adds an empty filter to an inserter when first placed if that inserter's drop location will instantly destroy items.
- Also detects the case when the drop position tile is marked for deconstruction above a destructive tile, making the inserter a ticking time bomb.
- Works equally with directly placed inserters, inserters placed on space platforms, and ghost inserters place either with Shift+Click or through remote view.

## Caveats

- Does not apply any safety filter to inserters that are placed as part of a blueprint.
