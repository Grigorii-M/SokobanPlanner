use game_engine::*;

struct Application {}

impl GameObject for Application {
    fn update(
        &mut self,
        game_state: &mut GameState,
        graphics_engine: &mut gfx::GraphicsEngine,
        input_handler: &mut input::InputHandler,
    ) {
        if input_handler.is_key_down(&input::VirtualKeyCode::Escape) {
            game_state.exit();
        }
    }
}

fn main() {
    let mut game = Game::new(
        "STRIPS Visualizer",
        WindowSettings {
            logical_width: 100,
            logical_height: 100,
            resize_mode: ResizeMode::KeepAspectRatio,
        }
    );
    
    let app = Application {};
    game.add_game_object(app);

    game.run();
}
