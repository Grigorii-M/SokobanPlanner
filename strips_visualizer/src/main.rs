use std::fs::File;
use std::io::prelude::*;
use clap::Parser;

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

struct Map {
    width: u32,
    height: u32,
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
                'G' => tiles.push(Tile::Goal),
                '*' => tiles.push(Tile::BoxGoal),
                ' ' => tiles.push(Tile::Empty),
                _ => {},
            }
        }

        let width = map_str.split('\n').next().unwrap().len() as u32;
        let height = tiles.len() as u32 / width;

        Self {
            width,
            height,
            tiles,
        }
    }

    fn show_map(&self) {
        let mut width_count = 0;
        for i in &self.tiles {
            print!("{:?}", i);
            width_count += 1;
            if width_count == self.width {
                println!();
                width_count = 0;
            }
        }
    }
}

enum Actions {
    Move(u32, u32),
    PushBox(u32, u32, u32),
    PullBox(u32, u32, u32),
    PushBomb(u32, u32, u32),
    PullBomb(u32, u32, u32),
    DestroyWall(u32, u32, u32),
    DestroyBox(u32, u32, u32),
    MakeBoxMovable(u32, u32, u32),
}

fn parse_plan(plan_str: &str, map_width: u32) -> Vec<Actions> {
    let mut actions = vec![];
    let parse_tile_index = |tile: &str| -> u32 {
        let letters = tile.split('_').collect::<Vec<_>>();
        let x = u32::from_str_radix(letters[1], 10).unwrap();
        let y = u32::from_str_radix(letters[2], 10).unwrap();

        y * map_width + x
    };

    plan_str.split('\n').for_each(|line| {
        let operands = line.split(' ').collect::<Vec<_>>();
        match operands[1] {
            "MOVE" => {
                let current_pos = parse_tile_index(operands[2]);
                let next_pos = parse_tile_index(operands[3]);
                actions.push(Actions::Move(current_pos, next_pos));
            },
            "PUSH_BOX" => { let current_pos = parse_tile_index(operands[2]);
                let next_pos = parse_tile_index(operands[3]);
                let box_next_pos = parse_tile_index(operands[4]);
                actions.push(Actions::PushBox(current_pos, next_pos, box_next_pos));
            },
            "PULL_BOX" => {
                let box_pos = parse_tile_index(operands[2]);
                let current_pos = parse_tile_index(operands[3]);
                let next_pos = parse_tile_index(operands[4]);
                actions.push(Actions::PullBox(box_pos, current_pos, next_pos));
            },
            "PUSH_BOMB" => {
                let current_pos = parse_tile_index(operands[2]);
                let next_pos = parse_tile_index(operands[3]);
                let box_next_pos = parse_tile_index(operands[4]);
                actions.push(Actions::PushBomb(current_pos, next_pos, box_next_pos));
            },
            "PULL_BOMB" => {
                let box_pos = parse_tile_index(operands[2]);
                let current_pos = parse_tile_index(operands[3]);
                let next_pos = parse_tile_index(operands[4]);
                actions.push(Actions::PullBomb(box_pos, current_pos, next_pos));
            },
            "DESTROY_WALL" => {
                let current_pos = parse_tile_index(operands[2]);
                let bomb_position = parse_tile_index(operands[3]);
                let wall_position = parse_tile_index(operands[5]);
                actions.push(Actions::DestroyWall(current_pos, bomb_position, wall_position));
            },
            "DESTROY_BOX" => {
                let current_pos = parse_tile_index(operands[2]);
                let bomb_position = parse_tile_index(operands[3]);
                let box_position = parse_tile_index(operands[5]);
                actions.push(Actions::DestroyBox(current_pos, bomb_position, box_position));
            },
            "MAKE_BOX_MOVABLE" => {
                let current_pos = parse_tile_index(operands[2]);
                let bomb_position = parse_tile_index(operands[3]);
                let box_position = parse_tile_index(operands[5]);
                actions.push(Actions::MakeBoxMovable(current_pos, bomb_position, box_position));
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

fn main() -> std::io::Result<()> {
    let args = Args::parse();

    let mut map_file = File::open(args.map_file)?;
    let mut map_str = String::new();
    map_file.read_to_string(&mut map_str)?;
    let map = Map::from_file(&map_str);
    map.show_map();

    let mut plan_file = File::open(args.plan_file)?;
    let mut plan_str = String::new();
    plan_file.read_to_string(&mut plan_str)?;
    println!("{plan_str}");
    let actions = parse_plan(&plan_str, map.width);
    
    Ok(())
}
