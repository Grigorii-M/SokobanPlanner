use std::fs::File;
use std::io::prelude::*;
use clap::Parser;
use game_engine::*;
use game_engine::gfx::gfx_2d::Sprite;
use game_engine::gfx::texture::Color;

struct Application {
    map: Map,
    actions: Vec<Action>,
    iter: usize,
}

impl GameObject for Application {
    fn update(
        &mut self,
        game_state: &mut game_engine::GameState,
        graphics_engine: &mut game_engine::gfx::GraphicsEngine,
        input_handler: &mut game_engine::input::InputHandler,
    ) {
        if input_handler.is_key_down(&input::VirtualKeyCode::Escape) {
            game_state.exit();
        }
        
        if input_handler.is_key_down(&input::VirtualKeyCode::Right) {
            if self.iter == self.actions.len() {
                println!("{}/{}: {:?}", self.iter - 1, self.actions.len(), self.actions[self.iter - 1]);
                self.map.show();
                let screen = graphics_engine.renderer_2d.foreground();
                for (i, t) in self.map.tiles.iter().enumerate() {
                    let square = Sprite::new(100, 100, t.get_color());
                    let x = i % self.map.width;
                    let y = i / self.map.width;

                    screen.draw_sprite(&square, (x as i32 * 100, y as i32 * 100).into());
                }
                return;
            }

            if self.iter != 0 {
                println!("{}/{}: {:?}", self.iter - 1, self.actions.len(), self.actions[self.iter - 1]);
            }
            self.map.show();

            let screen = graphics_engine.renderer_2d.foreground();
            for (i, t) in self.map.tiles.iter().enumerate() {
                let square = Sprite::new(100, 100, t.get_color());
                let x = i % self.map.width;
                let y = i / self.map.width;

                screen.draw_sprite(&square, (x as i32 * 100, y as i32 * 100).into());
            }

            if self.iter < self.actions.len() {
                self.map.modify(&self.actions[self.iter]);
            }

            self.iter += 1;
        }
    }
}

#[derive(Debug)]
enum Tile {
    Empty,
    Inaccessible,
    Sokoban,
    MovableBox,
    ImmovableBox,
    Bomb,
    Wall,
    Floor,
    BoxGoal,
    Goal,
}

impl Tile {
    fn get_color(&self) -> Color {
        match self {
            Tile::Empty => Color::BLACK,
            Tile::Inaccessible => Color::BLACK,
            Tile::Sokoban => Color::WHITE,
            Tile::MovableBox => Color::new(255, 180, 0, 255), // orange 255 180 0
            Tile::ImmovableBox => Color::new(130, 101, 33, 255), // 130 101 33
            Tile::Bomb => Color::RED, // red
            Tile::Wall => Color::new(3, 19, 89, 255), // 3 19 89
            Tile::Floor => Color::new(32, 32, 32, 255), // 32 32 32
            Tile::BoxGoal => Color::new(204, 255, 0, 255), // 204 255 o
            Tile::Goal => Color::MAGENTA, // magenta
        }
    }
}

impl std::fmt::Display for Tile {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Tile::Empty => write!(f, " "), // black
            Tile::Inaccessible => write!(f, "X"), // black
            Tile::Sokoban => write!(f, "S"), // white
            Tile::MovableBox => write!(f, "b"), // orange 255 180 0
            Tile::ImmovableBox => write!(f, "c"), // 130 101 33
            Tile::Bomb => write!(f, "B"), // red
            Tile::Wall => write!(f, "W"), // 3 19 89
            Tile::Floor => write!(f, "_"), // 32 32 32
            Tile::BoxGoal => write!(f, "*"), // 204 255 o
            Tile::Goal => write!(f, "G"), // magenta
        }
    }
}

struct Map {
    width: usize,
    height: usize,
    tiles: Vec<Tile>,
}

impl Map {
    fn from_file(map_str: &str) -> Self {
        let mut tiles = vec![];
        for ch in map_str.chars() {
            match ch {
                'S' => tiles.push(Tile::Sokoban),
                'B' => tiles.push(Tile::Bomb),
                'b' => tiles.push(Tile::MovableBox),
                'c' => tiles.push(Tile::ImmovableBox),
                '_' => tiles.push(Tile::Floor),
                'W' => tiles.push(Tile::Wall),
                'X' => tiles.push(Tile::Inaccessible),
                // 'G' => tiles.push(Tile::Goal),
                // '*' => tiles.push(Tile::BoxGoal),
                'G' => tiles.push(Tile::Floor),
                '*' => tiles.push(Tile::Floor),
                ' ' => tiles.push(Tile::Empty),
                _ => {},
            }
        }

        let width = map_str.split('\n').next().unwrap().len();
        let height = tiles.len() / width;

        Self {
            width,
            height,
            tiles,
        }
    }

    fn show(&self) {
        let mut width_count = 0;
        for i in &self.tiles {
            print!("{}", i);
            width_count += 1;
            if width_count == self.width {
                println!();
                width_count = 0;
            }
        }
        println!();
    }

    fn modify(&mut self, action: &Action) {
        match action {
            Action::Move(current_pos, next_pos) => {
                self.tiles[*current_pos] = Tile::Floor;
                self.tiles[*next_pos] = Tile::Sokoban;
            },
            Action::PushBox(current_pos, next_pos, box_next_pos) => {
                self.tiles[*current_pos] = Tile::Floor;
                self.tiles[*next_pos] = Tile::Sokoban;
                self.tiles[*box_next_pos] = Tile::MovableBox;
            },
            Action::PullBox(box_pos, current_pos, next_pos) => {
                self.tiles[*box_pos] = Tile::Floor;
                self.tiles[*current_pos] = Tile::MovableBox;
                self.tiles[*next_pos] = Tile::Sokoban;
            },
            Action::PushBomb(current_pos, next_pos, bomb_next_pos) => {
                self.tiles[*current_pos] = Tile::Floor;
                self.tiles[*next_pos] = Tile::Sokoban;
                self.tiles[*bomb_next_pos] = Tile::Bomb;
            },
            Action::PullBomb(bomb_pos, current_pos, next_pos) => {
                self.tiles[*bomb_pos] = Tile::Floor;
                self.tiles[*current_pos] = Tile::Bomb;
                self.tiles[*next_pos] = Tile::Sokoban;
            },
            Action::DestroyWall(_, bomb_pos, wall_pos) => {
                self.tiles[*bomb_pos] = Tile::Floor;
                self.tiles[*wall_pos] = Tile::Floor;
            },
            Action::DestroyBox(_, bomb_pos, box_pos) => {
                self.tiles[*bomb_pos] = Tile::Floor;
                self.tiles[*box_pos] = Tile::Floor;
            },
            Action::MakeBoxMovable(_, bomb_pos, box_pos) => {
                self.tiles[*bomb_pos] = Tile::Floor;
                self.tiles[*box_pos] = Tile::MovableBox;
            },
        }
    }
}

#[derive(Debug)]
enum Action {
    Move(usize, usize),
    PushBox(usize, usize, usize),
    PullBox(usize, usize, usize),
    PushBomb(usize, usize, usize),
    PullBomb(usize, usize, usize),
    DestroyWall(usize, usize, usize),
    DestroyBox(usize, usize, usize),
    MakeBoxMovable(usize, usize, usize),
}

fn parse_plan(plan_str: &str, map_width: usize) -> Vec<Action> {
    let parse_tile_index = |tile: &str| -> usize {
        let letters = tile.split('_').collect::<Vec<_>>();
        let x = usize::from_str_radix(letters[1], 10).unwrap();
        let y = usize::from_str_radix(letters[2], 10).unwrap();

        y * map_width + x
    };

    let plan_str = plan_str.trim();
    let mut actions = vec![];
    plan_str.split('\n').for_each(|line| {
        let operands = line.split(' ').collect::<Vec<_>>();
        match operands[1] {
            "MOVE" => {
                let current_pos = parse_tile_index(operands[2]);
                let next_pos = parse_tile_index(operands[3]);
                actions.push(Action::Move(current_pos, next_pos));
            },
            "PUSH_BOX" => {
                let current_pos = parse_tile_index(operands[2]);
                let next_pos = parse_tile_index(operands[3]);
                let box_next_pos = parse_tile_index(operands[4]);
                actions.push(Action::PushBox(current_pos, next_pos, box_next_pos));
            },
            "PULL_BOX" => {
                let box_pos = parse_tile_index(operands[2]);
                let current_pos = parse_tile_index(operands[3]);
                let next_pos = parse_tile_index(operands[4]);
                actions.push(Action::PullBox(box_pos, current_pos, next_pos));
            },
            "PUSH_BOMB" => {
                let current_pos = parse_tile_index(operands[2]);
                let next_pos = parse_tile_index(operands[3]);
                let bomb_next_pos = parse_tile_index(operands[4]);
                actions.push(Action::PushBomb(current_pos, next_pos, bomb_next_pos));
            },
            "PULL_BOMB" => {
                let bomb_pos = parse_tile_index(operands[2]);
                let current_pos = parse_tile_index(operands[3]);
                let next_pos = parse_tile_index(operands[4]);
                actions.push(Action::PullBomb(bomb_pos, current_pos, next_pos));
            },
            "DESTROY_WALL" => {
                let current_pos = parse_tile_index(operands[2]);
                let bomb_pos = parse_tile_index(operands[3]);
                let wall_pos = parse_tile_index(operands[5]);
                actions.push(Action::DestroyWall(current_pos, bomb_pos, wall_pos));
            },
            "DESTROY_BOX" => {
                let current_pos = parse_tile_index(operands[2]);
                let bomb_pos = parse_tile_index(operands[3]);
                let box_pos = parse_tile_index(operands[5]);
                actions.push(Action::DestroyBox(current_pos, bomb_pos, box_pos));
            },
            "MAKE_BOX_MOVABLE" => {
                let current_pos = parse_tile_index(operands[2]);
                let bomb_pos = parse_tile_index(operands[3]);
                let box_pos = parse_tile_index(operands[5]);
                actions.push(Action::MakeBoxMovable(current_pos, bomb_pos, box_pos));
            },
            _ => unreachable!(),
        }
    });

    actions
}

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    #[arg(short, long)]
    map_file: String,

    #[arg(short, long)]
    plan_file: String,
}


fn animate(map: &mut Map, actions: &Vec<Action>) {
    map.show();
    print!("\n\n\n");
    for action in actions {
        map.modify(action);
        map.show();
        print!("\n\n\n");
    }
}

fn main() -> std::io::Result<()> {
    let args = Args::parse();

    let mut map_file = File::open(args.map_file)?;
    let mut map_str = String::new();
    map_file.read_to_string(&mut map_str)?;
    let mut map = Map::from_file(&map_str);

    let mut plan_file = File::open(args.plan_file)?;
    let mut plan_str = String::new();
    plan_file.read_to_string(&mut plan_str)?;
    let actions = parse_plan(&plan_str, map.width);
    
    // animate(&mut map, &actions);

    let mut game = Game::new(
        "STRIPS visualizer",
        WindowSettings {
            logical_width: map.width as u32 * 100,
            logical_height: map.height as u32 * 100,
            resize_mode: ResizeMode::NoResize,
        }
    );

    let app = Application {
        map,
        actions,
        iter: 0,
    };

    game.add_game_object(app);

    game.run();

    Ok(())
}
