;;;; Here we test, whether Sokoban can blow boxes up

(define (problem blow_stuff_up)
  (:domain SokobanOnSteroids)
  (:objects
    ;;; The map
    ;; b _ B
    ;; b _ _
    ;; _ B _
    ;;   S

    t_0_0 - tile
    t_0_1 - tile
    t_0_2 - tile

    t_1_0 - tile
    t_1_1 - tile
    t_1_2 - tile

    t_2_0 - tile
    t_2_1 - tile
    t_2_2 - tile
    
    t_1_3 - tile

    ;;; Other
    box1 - box
    box2 - box
    bomb1 - bomb
    bomb2 - bomb
  )

  (:init
    ;;; Set up the map
    ;; Make things adjacent
    ; Vertical
    (adjacent t_0_0 t_1_0)(adjacent t_1_0 t_0_0)
    (adjacent t_1_0 t_2_0)(adjacent t_2_0 t_1_0)

    (adjacent t_0_1 t_1_1)(adjacent t_1_1 t_0_1)
    (adjacent t_1_1 t_2_1)(adjacent t_2_1 t_1_1)

    (adjacent t_0_2 t_1_2)(adjacent t_1_2 t_0_2)
    (adjacent t_1_2 t_2_2)(adjacent t_2_2 t_1_2)
    
    (adjacent t_1_3 t_1_2)(adjacent t_1_2 t_1_3)

    ; Horizontal
    (adjacent t_0_0 t_0_1)(adjacent t_0_1 t_0_0)
    (adjacent t_1_0 t_1_1)(adjacent t_1_1 t_1_0)
    (adjacent t_2_0 t_2_1)(adjacent t_2_1 t_2_0)

    (adjacent t_0_1 t_0_2)(adjacent t_0_2 t_0_1)
    (adjacent t_1_1 t_1_2)(adjacent t_1_2 t_1_1)
    (adjacent t_2_1 t_2_2)(adjacent t_2_2 t_2_1)

    ;; Configure directions
    (same_direction t_0_0 t_1_0 t_2_0)(same_direction t_2_0 t_1_0 t_0_0)
    (same_direction t_0_1 t_1_1 t_2_1)(same_direction t_2_1 t_1_1 t_0_1)
    (same_direction t_0_2 t_1_2 t_2_2)(same_direction t_2_2 t_1_2 t_0_2)
    
    (same_direction t_0_0 t_0_1 t_0_2)(same_direction t_0_2 t_0_1 t_0_0)
    (same_direction t_1_0 t_1_1 t_1_2)(same_direction t_1_2 t_1_1 t_1_0)
    (same_direction t_2_0 t_0_1 t_2_2)(same_direction t_2_2 t_2_1 t_2_0)

    (same_direction t_1_1 t_1_2 t_1_3)(same_direction t_1_3 t_1_2 t_1_1)

    ;;; Set up the objects
    (sokoban_at t_1_3)

    (entity_at bomb1 t_1_2)
    (inaccessible t_1_2)

    (entity_at bomb2 t_2_0)
    (inaccessible t_2_0)

    (entity_at box1 t_0_0)
    (inaccessible t_0_0)
    
    (entity_at box2 t_0_1)
    (inaccessible t_0_1)
  )

  (:goal
    (and
      (not (entity_at box1 t_0_0))
      (not (entity_at box1 t_0_1))
      (not (entity_at box1 t_0_2))
      (not (entity_at box1 t_1_0))
      (not (entity_at box1 t_1_1))
      (not (entity_at box1 t_1_2))
      (not (entity_at box1 t_1_3))
      (not (entity_at box1 t_2_0))
      (not (entity_at box1 t_2_1))
      (not (entity_at box1 t_2_2))

      (not (entity_at box2 t_0_0))
      (not (entity_at box2 t_0_1))
      (not (entity_at box2 t_0_2))
      (not (entity_at box2 t_1_0))
      (not (entity_at box2 t_1_1))
      (not (entity_at box2 t_1_2))
      (not (entity_at box2 t_1_3))
      (not (entity_at box2 t_2_0))
      (not (entity_at box2 t_2_1))
      (not (entity_at box2 t_2_2))
      (not (entity_at bomb1 t_1_2))
    )
  )
)
