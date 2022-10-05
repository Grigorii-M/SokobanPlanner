(define (domain SokobanOnSteroids)
  (:requirements
    :strips
    :negative-preconditions
  )

  (:types
    entity location - object

    tile - location
    
    box - entity
    bomb - entity
    wall - entity
  )

  (:predicates
    (sokoban_at ?p - tile) ;; whether sokoban is at position x
    (entity_at ?o - entity ?t - tile)
    (adjacent ?x - tile ?y - tile) ;; whether x tile is adjacent to y tile
    ;; whether movements x -> y and y -> z are in the same direction
    (same_direction ?x - tile ?y - tile ?x - tile)
    (inaccessible ?x - tile)
    (box_immovable ?b - box)
  )

  (:action move
    :parameters(?x - tile ?y - tile)
    :precondition(and (sokoban_at ?x) (adjacent ?x ?y) (not (inaccessible ?y)))
    :effect(and (not (sokoban_at ?x)) (sokoban_at ?y))
  )

  (:action push_box
    :parameters(
      ?x - tile ;; sokoban's current position
      ?y - tile ;; sokoban's next position and the box' current position
      ?z - tile ;; box' new position
      ?b - box
    )
    :precondition(and
      (sokoban_at ?x)
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (not (inaccessible ?z))
      (entity_at ?b ?y)
      (same_direction ?x ?y ?z)
      (not (box_immovable ?b))
    )
    :effect(and
      (not (sokoban_at ?x))
      (sokoban_at ?y)
      (not (entity_at ?b ?y))
      (entity_at ?b ?z)
      (not (inaccessible ?y))
      (inaccessible ?z)
    )
  )

  (:action pull_box
    :parameters(
      ?z - tile ;; box' current position
      ?y - tile ;; sokoban's current position and the box' next position
      ?x - tile ;; sokoban's next position
      ?b - box
    )
    :precondition(and
      (sokoban_at ?y)
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (not (inaccessible ?x))
      (entity_at ?b ?z)
      (same_direction ?x ?y ?z)
      (not (box_immovable ?b))
    )
    :effect(and
      (not (sokoban_at ?y))
      (sokoban_at ?x)
      (not (entity_at ?b ?z))
      (entity_at ?b ?y)
      (not (inaccessible ?z))
      (inaccessible ?y)
    )
  )
  
  (:action push_bomb
    :parameters(
      ?x - tile ;; sokoban's current position
      ?y - tile ;; sokoban's next position and the box' current position
      ?z - tile ;; box' new position
      ?b - bomb
    )
    :precondition(and
      (sokoban_at ?x)
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (not (inaccessible ?z))
      (entity_at ?b ?y)
      (same_direction ?x ?y ?z)
    )
    :effect(and
      (not (sokoban_at ?x))
      (sokoban_at ?y)
      (not (entity_at ?b ?y))
      (entity_at ?b ?z)
      (not (inaccessible ?y))
      (inaccessible ?z)
    )
  )

  (:action pull_bomb
    :parameters(
      ?z - tile ;; box' current position
      ?y - tile ;; sokoban's current position and the box' next position
      ?x - tile ;; sokoban's next position
      ?b - bomb
    )
    :precondition(and
      (sokoban_at ?y)
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (not (inaccessible ?x))
      (entity_at ?b ?z)
      (same_direction ?x ?y ?z)
    )
    :effect(and
      (not (sokoban_at ?y))
      (sokoban_at ?x)
      (not (entity_at ?b ?z))
      (entity_at ?b ?y)
      (not (inaccessible ?z))
      (inaccessible ?y)
    )
  )

  (:action destroy_wall
    :parameters(
      ?x - tile ;; sokoban's current position
      ?y - tile ;; bomb's position
      ?b - bomb

      ?t - tile
      ?e - wall
    )
    :precondition(and
      (sokoban_at ?x)
      (entity_at ?b ?y)
      (entity_at ?e ?t)
      (adjacent ?x ?y)
      (same_direction ?x ?y ?t)
    )
    :effect(and
      (not (entity_at ?b ?y))
      (not (inaccessible ?y))
      (not (entity_at ?e ?t))
      (not (inaccessible ?t))
    )
  )

  (:action destroy_box
    :parameters(
      ?x - tile ;; sokoban's current position
      ?y - tile ;; bomb's position
      ?b - bomb

      ?t - tile
      ?e - box
    )
    :precondition(and
      (sokoban_at ?x)
      (entity_at ?b ?y)
      (entity_at ?e ?t)
      (adjacent ?x ?y)
      (same_direction ?x ?y ?t)
      (not (box_immovable ?e))
    )
    :effect(and
      (not (entity_at ?b ?y))
      (not (inaccessible ?y))
      (not (entity_at ?e ?t))
      (not (inaccessible ?t))
    )
  )
  
  (:action make_box_movable
    :parameters(
      ?x - tile ;; sokoban's current position
      ?y - tile ;; bomb's position
      ?b - bomb

      ?t - tile
      ?e - box
    )
    :precondition(and
      (sokoban_at ?x)
      (entity_at ?b ?y)
      (entity_at ?e ?t)
      (adjacent ?x ?y)
      (same_direction ?x ?y ?t)
      (box_immovable ?e)
    )
    :effect(and
      (not (entity_at ?b ?y))
      (not (inaccessible ?y))
      (not (box_immovable ?e))
    )
  )
)
