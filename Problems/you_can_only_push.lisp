;;;; Here we test, whether Sokoban can push the box

(define (problem you_can_only_push)
  (:domain SokobanOnSteroids)
  (:objects
    ;;; The map
    ;; S
    ;; _
    ;; b _ G
    ;; _

    t_0_0 - tile
    t_0_1 - tile
    t_0_2 - tile
    t_0_3 - tile

    t_1_2 - tile
    t_2_2 - tile

    ;;; Other
    box1 - box
  )

  (:init
    ;;; Set up the map
    ;; Make things adjacent
    (adjacent t_0_0 t_0_1)(adjacent t_0_1 t_0_0)
    (adjacent t_0_1 t_0_2)(adjacent t_0_2 t_0_1)
    (adjacent t_0_2 t_0_3)(adjacent t_0_3 t_0_2)

    (adjacent t_0_2 t_1_2)(adjacent t_1_2 t_0_2)
    (adjacent t_1_2 t_2_2)(adjacent t_2_2 t_1_2)

    ;; Configure directions
    (same_direction t_0_0 t_0_1 t_0_2)(same_direction t_0_2 t_0_1 t_0_0)
    (same_direction t_0_1 t_0_2 t_0_3)(same_direction t_0_3 t_0_2 t_0_1)
    (same_direction t_0_2 t_1_2 t_2_2)(same_direction t_2_2 t_1_2 t_0_2)

    ;;; Set up the objects
    (sokoban_at t_0_0)
    (entity_at box1 t_0_2)
    (inaccessible t_0_2)
  )

  (:goal
    (sokoban_at t_2_2)
  )
)
