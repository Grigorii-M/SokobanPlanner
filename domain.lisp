(define (domain SokobanOnSteroids)
  (:requirements
    :strips
    :negative-preconditions
  )

  (:types
    object location agent - type
    box - object
    tile - location
  )

  (:constants

  )

  (:predicates
    (at ?x - agent ?p - tile) ;; whether sokoban is at position x
    (object_at ?x - object ?p - tile)
    (adjacent ?x - tile ?y - tile) ;; whether x tile is adjacent to y tile
    ;; whether movements x -> y and y -> z are in the same direction
    (same_direction ?x - tile ?y - tile ?x - tile)
    (inaccessible ?x - tile)
  )

  (:action move
    :parameters(?x - tile ?y - tile)
    :precondition(and (at sokoban ?x) (adjacent ?x ?y) (not (inaccessible ?y)))
    :effect(and (not (at sokoban ?x)) (at sokoban ?y))
  )

  (:action push
    :parameters(
      ?x - tile ;; sokoban's current position
      ?y - tile ;; sokoban's next position and the box' current position
      ?z - tile ;; box' new position
      ?obj - box
    )
    :precondition(and
      (at sokoban ?x)
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (object_at ?obj ?y)
      (same_direction ?x ?y ?z)
    )
    :effect(and
      (not (at sokoban ?x))
      (at sokoban ?y)
      (not (object_at ?obj ?y))
      (object_at ?obj ?z)
      (not (inaccessible ?y))
      (inaccessible ?z)
    )
  )

  (:action pull
    :parameters(
      ?x - tile ;; sokoban's next position
      ?y - tile ;; sokoban's current position and the box' next position
      ?z - tile ;; box' current position
      ?obj - box
    )
    :precondition(and
      (at sokoban ?y)
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (object_at ?obj ?z)
      (same_direction ?x ?y ?z)
    )
    :effect(and
      (not (at sokoban ?y))
      (at sokoban ?x)
      (not (object_at ?obj ?z))
      (object_at ?obj ?y)
      (not (inaccessible ?z))
      (inaccessible ?y)
    )
  )
)
