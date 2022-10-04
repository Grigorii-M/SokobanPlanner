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
  )

  (:action move
    :parameters(?x - tile ?y - tile)
    :precondition(and (at sokoban ?x) (adjacent ?x ?y))
    :effect(and (not(at sokoban ?x)) (at sokoban ?y))
  )

  (:action push
    :parameters(
      ?px - tile ;; sokoban's current position
      ?py - tile ;; sokoban's next position and the box' current position
      ?ox - tile ;; box' new position
      ?obj - box
    )
    :precondition(and
      (at sokoban ?px)
      (adjacent ?px ?py)
      (object_at ?obj ?py)
      (same_direction ?px ?py ?ox)
    )
    :effect(and
      (not(at sokoban ?px))
      (at sokoban ?py)
      (not (object_at box1 ?py))
      (object_at ?obj ?ox)
    )
  )
)
