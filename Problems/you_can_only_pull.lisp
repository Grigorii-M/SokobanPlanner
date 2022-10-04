;;;; Here we test, whether Sokoban can pull box

(define (problem you_can_only_pull)
  (:domain SokobanOnSteroids)
  (:objects
    ;;; The map
    ;; S _ _
    ;; _ _ _
    ;; _ _ _
    ;; b
    ;; _ _ G

    t_0_0 - tile
    t_1_0 - tile
    t_2_0 - tile

    t_0_1 - tile
    t_1_1 - tile
    t_2_1 - tile

    t_0_2 - tile
    t_1_2 - tile
    t_2_2 - tile

    t_0_3 - tile

    t_0_4 - tile
    t_1_4 - tile
    t_2_4 - tile

    ;;; Other
    sokoban - agent
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

    (adjacent t_0_2 t_1_2)(adjacent t_1_2 t_0_2)
    (adjacent t_1_2 t_2_2)(adjacent t_2_2 t_1_2)

    (adjacent t_0_4 t_1_4)(adjacent t_1_4 t_0_4)
    (adjacent t_1_4 t_2_4)(adjacent t_2_4 t_1_4)

    ; vertical
    (adjacent t_0_0 t_0_1)(adjacent t_0_1 t_0_0)
    (adjacent t_0_1 t_0_2)(adjacent t_0_2 t_0_1)

    (adjacent t_1_0 t_1_1)(adjacent t_1_1 t_1_0)
    (adjacent t_1_1 t_1_2)(adjacent t_1_2 t_1_1)

    (adjacent t_2_0 t_2_1)(adjacent t_2_1 t_2_0)
    (adjacent t_2_1 t_2_2)(adjacent t_2_2 t_2_1)

    (adjacent t_0_2 t_0_3)(adjacent t_0_3 t_0_2)
    (adjacent t_0_3 t_0_4)(adjacent t_0_4 t_0_3)

    ;; configure directions
    ; horizontal
    (same_direction t_0_0 t_1_0 t_2_0)(same_direction t_2_0 t_1_0 t_0_0)
    (same_direction t_0_1 t_1_1 t_2_1)(same_direction t_2_1 t_1_1 t_0_1)
    (same_direction t_0_2 t_1_2 t_2_2)(same_direction t_2_2 t_1_2 t_0_2)

    (same_direction t_0_4 t_1_0 t_2_4)(same_direction t_2_4 t_1_4 t_0_4)

    ; Vertical
    (same_direction t_0_0 t_0_1 t_0_2)(same_direction t_0_2 t_0_1 t_0_0)
    (same_direction t_1_0 t_1_1 t_1_2)(same_direction t_1_2 t_1_1 t_1_0)
    (same_direction t_2_0 t_2_1 t_2_2)(same_direction t_2_2 t_2_1 t_2_0)
    (same_direction t_0_1 t_0_2 t_0_3)(same_direction t_0_2 t_0_2 t_0_2)

    (same_direction t_0_1 t_0_2 t_0_3)(same_direction t_0_3 t_0_2 t_0_1)
    (same_direction t_0_2 t_0_3 t_0_4)(same_direction t_0_4 t_0_3 t_0_2)

    ;;; Set up the objects
    (at sokoban t_0_0)
    (object_at box1 t_0_3)
    (inaccessible t_0_3)
  )

  (:goal
    (at sokoban t_2_4)
  )
)
