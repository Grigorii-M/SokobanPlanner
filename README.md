# AI Planning using STRIPS
### By: Grigorii Matiukhin 

## Introduction

The objective of this laboratory work is to create a weak artificial intelligence with *Stanford Research Institute Problem Solver*.  
The domain should consist of at least six types of objects, six predicates and six actions.  
Additionally, create three or more problems in this domain.

## Domain description

My domain is based on an old game called [Sokoban](https://en.wikipedia.org/wiki/Sokoban) with several additions to make it more challenging.  
There is a new object - bomb, which can be used to destroy walls.  
In this version the player (Sokoban) can not only push boxes but also pull them.  
Some boxed can be immovable. In order to move them the player should blow them up with a bomb, however movable boxes can be destroyed by it.

### Types

The types of objects on which actions and predicates operate are organized in a hierarchy as follows:

+ type
  + location
    + tile
  + entity
    + box
    + bomb
    + wall

### Predicates

The domain uses six different predicates:

| Name             | Parameters                       | Description                                         |
|------------------|----------------------------------|-----------------------------------------------------|
| `sokoban_at`     | `x` - tile                       | Is Sokoban on the tile `x`                          |
| `entity_at`      | `e` - entity `x` - tile          | Is entity `e` on the tile `x`                       |
| `adjacent`       | `x` - tile `y` - tile            | Are tiles `x` and `y` directly adjacent             |
| `same_direction` | `x` - tile `y` - tile `z` - tile | Do tiles `x`, `y` and `z` lay in the same direction |
| `inaccessible`   | `x` - tile                       | Can tile `x` be stepped on                          |
| `box_immovable`  | `b` - box                        | Can box `b` be moved                                |

##### Notes

The last two predicates are negated by design, because it is less time consuming to mark several tiles and boxes as inaccessible and immovable rather than marking allmost all as accessible and movable.  
It is assumed by all of the actions that move or destroy boxes, walls and bombs that the tiles on which they stay are marked as inaccessible. Though any tile can be marked as inaccessible.

### Actions

To reach the goal Sokoban can use eight different actions:

+ `move(x - tile, y - tile)` - Sokoban moves from tile `x` to tile `y` if they are adjacent and tile `y` is not inaccessible

  - Precondition:
    ```
    (and
      (sokoban_at ?x)
      (adjacent ?x ?y)
      (not (inaccessible ?y))
    )
    ```

  - Effect:
    ```
    (and
      (not (sokoban_at ?x))
      (sokoban_at ?y)
    )
     ```

+ `push_box(?x - tile ?y - tile ?z - tile ?b - box)` - moves from tile `x` to tile `y` and pushes box `b` from tile `y` to tile `z` if `x`, `y` and `z` lay in the same direction and box is not immovable

  - Precondition:
    ```
    (and
        (sokoban_at ?x)
        (or (adjacent ?x ?y) (adjacent ?y ?x))
        (or (adjacent ?x ?y) (adjacent ?y ?x))
        (not (inaccessible ?z))
        (entity_at ?b ?y)
        (same_direction ?x ?y ?z)
        (not (box_immovable ?b))
      )
    ```

  - Effect:
    ```
    (and
      (not (sokoban_at ?x))
      (sokoban_at ?y)
      (not (entity_at ?b ?y))
      (entity_at ?b ?z)
      (not (inaccessible ?y))
      (inaccessible ?z)
    )
    ```

+ `pull_box(?z - tile ?y - tile ?x - tile ?b - box)` - moves from tile `y` to tile `x` and pulls box `b` from tile `z` to `y` if `z` if `x`, `y` and `z` lay in the same direction and box is not immovable

  - Precondition:
    ```
    (and
      (sokoban_at ?y)
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (not (inaccessible ?x))
      (entity_at ?b ?z)
      (same_direction ?x ?y ?z)
      (not (box_immovable ?b))
    )
    ```

  - Effect:
    ```
    (and
      (not (sokoban_at ?y))
      (sokoban_at ?x)
      (not (entity_at ?b ?z))
      (entity_at ?b ?y)
      (not (inaccessible ?z))
      (inaccessible ?y)
    )
    ```

+ `push_bomb(?x - tile ?y - tile ?z - tile ?b - bomb)` - does the same thing as `push_box` ommiting the check for movablility, that is why it is impossible to combine theese two actions into one

+ `pull_bomb(?z - tile ?y - tile ?x - tile ?b - bomb)` - does the same thing as `pull_box` ommiting the check for movablility, that is why it is impossible to combine theese two actions into one

+ `destroy_wall(?x - tile ?y - tile ?b - bomb ?z - tile ?w - wall)` - detonates the bomb on tile `y` to destroy the wall on tile `z` if `x`, `y` and `z` lay in the same direction

  - Precondition:
    ```
    (and
      (sokoban_at ?x)
      (entity_at ?b ?y)
      (entity_at ?w ?z)
      (adjacent ?x ?y)
      (same_direction ?x ?y ?z)
    )
    ```

  - Effect:
    ```
    (and
      (not (entity_at ?b ?y))
      (not (inaccessible ?y))
      (not (entity_at ?w ?z))
      (not (inaccessible ?z))
    )
    ```

+ `destroy_box(?x - tile ?y - tile ?b - bomb ?z - tile ?e - box)` - works the same way as `destroy_wall` but needs the box `e` to be movable

+ `make_box_movable(?x - tile ?y - tile ?b - bomb ?z - tile ?e - box)` - detonates the bomb on tile `y` and makes the box `e` movable

  - Precondition:
    ```
    (and
      (sokoban_at ?x)
      (entity_at ?b ?y)
      (entity_at ?e ?z)
      (adjacent ?x ?y)
      (same_direction ?x ?y ?z)
      (box_immovable ?e)
    )

    ```
    
  - Effect:
    ```
    (and
      (not (entity_at ?b ?y))
      (not (inaccessible ?y))
      (not (box_immovable ?e))
    )
    ```

## Problems

The set of example problems this planner can solve could be found in `Problems` directory, their soulutions are in `Plans` directory.  
They were used during testing of the planner, therefore each problem tries to focus on one feature.

| Name                     | Description                                                                                                            |
|--------------------------|------------------------------------------------------------------------------------------------------------------------|
| move                     | This problem includes the biggest map of all. Here the ability to move in big spaces was tested.                       |
| you\_can\_only\_push     | The only solution to this problem requires pushing the box.                                                            |
| you\_can\_only\_pull     | The only solution to this problem requires pulling the box.                                                            |
| blow\_stuff\_up          | The goal is to destroy two boxes using two bombs.                                                                      |
| blow\_up\_walls          | The solution to this problem requires destroying the wall.                                                             |
| dont\_blow\_up\_the\_box | Was used to test the ability to destroy several things around the bomb. However, with current rules posseses no value. |
| turn\_movable         | The solution to this problem requires to turn immovable box into movable.                                              |

## Conclusion

The result of this work is a rather intelligent system that can solve a problem inside of its domain.
However there are several points where improvements could be made.  
One such improvement could be to replace predicates `entity_at` and `inaccessible` with only one predicate.
This predicate should make the tiles inaccessible only if there is something on them.
This will simplify the creation of the problems for the system to solve as well as the effects of several actions.
