;;;; Here we test, whether Sokoban can turn an immovable box into a movable one in order to push it

(define (problem turn_movable)
  (:domain SokobanOnSteroids)
  (:objects
    ;;; The map
    ;; _ _ _
    ;; c B S
    ;; *

    t_0_0 - tile
    t_1_0 - tile
    t_2_0 - tile
    
    t_0_1 - tile
    t_1_1 - tile
    t_2_1 - tile

    t_0_2 - tile

    ;;; Other
    box1 - box
    bomb1 - bomb
  )

  (:init
    ;;; Set up the map
    ;; Make things adjacent
    ; Horizontal
    (adjacent t_0_0 t_1_0)(adjacent t_1_0 t_0_0)
    (adjacent t_1_0 t_2_0)(adjacent t_2_0 t_1_0)

    (adjacent t_0_1 t_1_1)(adjacent t_1_1 t_0_1)
    (adjacent t_1_1 t_2_1)(adjacent t_2_1 t_1_1)

    ; Vertical
    (adjacent t_0_0 t_0_1)(adjacent t_0_1 t_0_0)
    (adjacent t_1_0 t_1_1)(adjacent t_1_1 t_1_0)
    (adjacent t_2_0 t_2_1)(adjacent t_2_1 t_2_0)

    (adjacent t_0_1 t_0_2)(adjacent t_0_2 t_0_1)

    ;; Configure directions
    (same_direction t_0_0 t_1_0 t_2_0)(same_direction t_2_0 t_1_0 t_0_0)
    (same_direction t_0_1 t_1_1 t_2_1)(same_direction t_2_1 t_1_1 t_0_1)

    (same_direction t_0_0 t_0_1 t_0_2)(same_direction t_0_2 t_0_1 t_0_0)

    ;;; Set up the objects
    (sokoban_at t_2_1)

    (entity_at box1 t_0_1)
    (box_immovable box1)
    (inaccessible t_0_1)

    (entity_at bomb1 t_1_1)
    (inaccessible t_1_1)
  )

  (:goal
    (entity_at box1 t_0_2)
  )
)
