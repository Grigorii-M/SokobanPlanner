;;;; Here we test, whether Sokoban can blow up walls to get to destination

(define (problem blow_up_walls)
  (:domain SokobanOnSteroids)
  (:objects
    ;;; The map
    ;;       _ _ _
    ;; * _ W _ B S
    ;;       b _ _

    t_3_0 - tile
    t_4_0 - tile
    t_5_0 - tile

    t_0_1 - tile
    t_1_1 - tile
    t_2_1 - tile
    t_3_1 - tile
    t_4_1 - tile
    t_5_1 - tile
    
    t_3_2 - tile
    t_4_2 - tile
    t_5_2 - tile

    wall1 - wall
    bomb1 - bomb
    box1 - box
  )

  (:init
    ;;; Set up the map
    ;; Make things adjacent
    ; Horizonal
    (adjacent t_3_0 t_4_0)(adjacent t_4_0 t_3_0)
    (adjacent t_4_0 t_5_0)(adjacent t_5_0 t_4_0)

    (adjacent t_0_1 t_1_1)(adjacent t_1_1 t_0_1)
    (adjacent t_1_1 t_2_1)(adjacent t_2_1 t_1_1)
    (adjacent t_2_1 t_3_1)(adjacent t_3_1 t_2_1)
    (adjacent t_3_1 t_4_1)(adjacent t_4_1 t_3_1)
    (adjacent t_4_1 t_5_1)(adjacent t_5_1 t_4_1)
    
    (adjacent t_3_2 t_4_2)(adjacent t_4_2 t_3_2)
    (adjacent t_4_2 t_5_2)(adjacent t_5_2 t_4_2)

    ; Vertical
    (adjacent t_3_0 t_3_1)(adjacent t_3_1 t_3_0)
    (adjacent t_3_1 t_3_2)(adjacent t_3_2 t_3_1)

    (adjacent t_4_0 t_4_1)(adjacent t_4_1 t_4_0)
    (adjacent t_4_1 t_4_2)(adjacent t_4_2 t_4_1)

    (adjacent t_5_0 t_5_1)(adjacent t_5_1 t_5_0)
    (adjacent t_5_1 t_5_2)(adjacent t_5_2 t_5_1)

    ;; Configure directions
    (same_direction t_0_1 t_1_1 t_2_1)(same_direction t_2_1 t_1_1 t_0_1)
    (same_direction t_1_1 t_2_1 t_3_1)(same_direction t_3_1 t_2_1 t_1_1)
    (same_direction t_2_1 t_3_1 t_4_1)(same_direction t_4_1 t_3_1 t_2_1)
    (same_direction t_3_1 t_4_1 t_5_1)(same_direction t_5_1 t_4_1 t_3_1)
    
    (same_direction t_3_0 t_3_1 t_3_2)(same_direction t_3_2 t_3_1 t_3_0)
    (same_direction t_4_0 t_4_1 t_4_2)(same_direction t_4_2 t_4_1 t_4_0)
    (same_direction t_5_0 t_5_1 t_5_2)(same_direction t_5_2 t_5_1 t_5_0)

    ;;; Set up the objects
    (sokoban_at t_5_1)
    (entity_at wall1 t_2_1)
    (entity_at bomb1 t_4_1)
    (entity_at box1 t_3_2)
    
    (inaccessible t_2_1)
    (inaccessible t_4_1)
    (inaccessible t_3_2)
  )

  (:goal
    (entity_at box1 t_0_1)
  )
)
