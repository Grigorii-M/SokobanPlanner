;;;; Here we only test, wheter Sokoban can avoid obstacles

(define (problem move)
  (:domain SokobanOnSteroids)
  (:objects
    ;;; The map
    ;; S _ X _ _
    ;; _ _ _ X _
    ;; _ _ _ X _
    ;; _ _ _ _ _
    ;; _ _ _ _ G

    t_0_0 - tile
    t_1_0 - tile
    t_2_0 - tile
    t_3_0 - tile
    t_4_0 - tile
    t_0_1 - tile
    t_1_1 - tile
    t_2_1 - tile
    t_3_1 - tile
    t_4_1 - tile
    t_0_2 - tile
    t_1_2 - tile
    t_2_2 - tile
    t_3_2 - tile
    t_4_2 - tile
    t_0_3 - tile
    t_1_3 - tile
    t_2_3 - tile
    t_3_3 - tile
    t_4_3 - tile
    t_0_4 - tile
    t_1_4 - tile
    t_2_4 - tile
    t_3_4 - tile
    t_4_4 - tile

    ;;; Other
    box1 - box
    bomb1 - bomb
  )

  (:init
    ;;; Set up the map
    ;; Make things adjacent
    ; Horizontal
    (adjacent t_0_0 t_1_0)(adjacent t_0_0 t_1_0)
    (adjacent t_1_0 t_2_0)(adjacent t_0_0 t_1_0)
    (adjacent t_2_0 t_3_0)(adjacent t_0_0 t_1_0)
    (adjacent t_3_0 t_4_0)(adjacent t_0_0 t_1_0)

    (adjacent t_0_1 t_1_1)(adjacent t_1_1 t_0_1)
    (adjacent t_1_1 t_2_1)(adjacent t_2_1 t_1_1)
    (adjacent t_2_1 t_3_1)(adjacent t_3_1 t_2_1)
    (adjacent t_3_1 t_4_1)(adjacent t_4_1 t_3_1)

    (adjacent t_0_2 t_1_2)(adjacent t_1_2 t_0_2)
    (adjacent t_1_2 t_2_2)(adjacent t_2_2 t_1_2)
    (adjacent t_2_2 t_3_2)(adjacent t_3_2 t_2_2)
    (adjacent t_3_2 t_4_2)(adjacent t_4_2 t_3_2)

    (adjacent t_0_3 t_1_3)(adjacent t_1_3 t_0_3)
    (adjacent t_1_3 t_2_3)(adjacent t_2_3 t_1_3)
    (adjacent t_2_3 t_3_3)(adjacent t_3_3 t_2_3)
    (adjacent t_3_3 t_4_3)(adjacent t_4_3 t_3_3)

    (adjacent t_0_4 t_1_4)(adjacent t_1_4 t_0_4)
    (adjacent t_1_4 t_2_4)(adjacent t_2_4 t_1_4)
    (adjacent t_2_4 t_3_4)(adjacent t_3_4 t_2_4)
    (adjacent t_3_4 t_4_4)(adjacent t_4_4 t_3_4)

    ; Horizontal
    (adjacent t_0_0 t_0_1)(adjacent t_0_1 t_0_0)
    (adjacent t_1_0 t_1_1)(adjacent t_1_1 t_1_0)
    (adjacent t_2_0 t_2_1)(adjacent t_2_1 t_2_0)
    (adjacent t_3_0 t_3_1)(adjacent t_3_1 t_3_0)
    (adjacent t_4_0 t_4_1)(adjacent t_4_1 t_4_0)

    (adjacent t_0_1 t_0_2)(adjacent t_0_2 t_0_1)
    (adjacent t_1_1 t_1_2)(adjacent t_1_2 t_1_1)
    (adjacent t_2_1 t_2_2)(adjacent t_2_2 t_2_1)
    (adjacent t_3_1 t_3_2)(adjacent t_3_2 t_3_1)
    (adjacent t_4_1 t_4_2)(adjacent t_4_2 t_4_1)

    (adjacent t_0_2 t_0_3)(adjacent t_0_3 t_0_2)
    (adjacent t_1_2 t_1_3)(adjacent t_1_3 t_1_2)
    (adjacent t_2_2 t_2_3)(adjacent t_2_3 t_2_2)
    (adjacent t_3_2 t_3_3)(adjacent t_3_3 t_3_2)
    (adjacent t_4_2 t_4_3)(adjacent t_4_3 t_4_2)

    (adjacent t_0_3 t_0_4)(adjacent t_0_4 t_0_3)
    (adjacent t_1_3 t_1_4)(adjacent t_1_4 t_1_3)
    (adjacent t_2_3 t_2_4)(adjacent t_2_4 t_2_3)
    (adjacent t_3_3 t_3_4)(adjacent t_3_4 t_3_3)
    (adjacent t_4_3 t_4_4)(adjacent t_4_4 t_4_3)

    ;;; Set up the objects
    (sokoban_at t_0_0)

    (inaccessible t_2_0)
    (inaccessible t_3_1)
    (inaccessible t_3_2)
  )

  (:goal
    (sokoban_at t_4_4)
  )
)
