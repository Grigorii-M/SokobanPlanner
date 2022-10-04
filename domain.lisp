(define (domain SokobanOnSteroids)
  (:requirements
    :strips
    :negative-preconditions
  )

  (:types
    object location agent - type
    tile - location
    box - object
    bomb - object
  )

  (:predicates
    (at ?x - agent ?p - tile) ;; whether sokoban is at position x
    (object_at ?o - object ?t - tile)
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
      ?b - object
    )
    :precondition(and
      (at sokoban ?x)
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (not (inaccessible ?z))
      (object_at ?b ?y)
      (same_direction ?x ?y ?z)
    )
    :effect(and
      (not (at sokoban ?x))
      (at sokoban ?y)
      (not (object_at ?b ?y))
      (object_at ?b ?z)
      (not (inaccessible ?y))
      (inaccessible ?z)
    )
  )

  (:action pull
    :parameters(
      ?x - tile ;; sokoban's next position
      ?y - tile ;; sokoban's current position and the box' next position
      ?z - tile ;; box' current position
      ?b - object
    )
    :precondition(and
      (at sokoban ?y)
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (or (adjacent ?x ?y) (adjacent ?y ?x))
      (not (inaccessible ?x))
      (object_at ?b ?z)
      (same_direction ?x ?y ?z)
    )
    :effect(and
      (not (at sokoban ?y))
      (at sokoban ?x)
      (not (object_at ?b ?z))
      (object_at ?b ?y)
      (not (inaccessible ?z))
      (inaccessible ?y)
    )
  )
  
  (:action detonate
    :parameters(
      ?x - tile ;; sokoban's current position
      ?y - tile ;; bomb's position
      ?b - bomb

      ?t1 - tile
      ?b1 - box

      ?t2 - tile
      ?b2 - box

      ?t3 - tile
      ?b3 - box
    )
    :precondition(and
      (at sokoban ?x)
      (object_at ?b ?y)
      (adjacent ?x ?y)
      (and
        (and (object_at ?b1 ?t1) (adjacent ?t1 ?y) (not (= ?t1 ?x)) (not (= ?t1 ?y)))
        (and (object_at ?b2 ?t2) (adjacent ?t2 ?y) (not (= ?t2 ?x)) (not (= ?t2 ?y)))
        (and (object_at ?b3 ?t3) (adjacent ?t3 ?y) (not (= ?t3 ?x)) (not (= ?t3 ?y)))
      )
    )
    :effect(and
      (not (object_at ?b ?y))
      (not (object_at ?b1 ?t1))
      (not (object_at ?b2 ?t2))
      (not (object_at ?b3 ?t3))
    )
  )
)
