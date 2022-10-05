use std::fs::File;
use std::io::prelude::*;
use clap::Parser;

enum Tile {
    Sokoban,
    MovableBox,
    ImmovableBox,
    Bomb,
    Wall,
    Floor,
}

struct Map {
    tiles: Vec<Tile>,
}

impl Map {
    fn from_file(file: &File) -> Self {
        Self {
            tiles: vec![],
        }
    }
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
    println!("{map_str}");

    let mut plan_file = File::open(args.plan_file)?;
    let mut plan_str = String::new();
    plan_file.read_to_string(&mut plan_str)?;
    println!("{plan_str}");
    
    Ok(())
}
