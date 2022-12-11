use std::io;
use std::io::Read;
use std::convert::TryInto;

fn main()
{
    let mut data = String::new();
    io::stdin().read_to_string(&mut data).expect(":(");
	let numbers = data.split_ascii_whitespace().map(|x| x.parse::<i32>());
    let mut x = 1;
    let mut task1 = 0;
    for (n, number) in numbers.enumerate()
    {
        let i:i32 = (n + 1).try_into().unwrap();
        if vec![20, 60, 100, 140, 180, 220].contains(&i)
        {
            task1 += i * x;
        }
        x += match number
        {
            Ok(i) => i,
            Err(_) => 0,
        };
    }
    println!("task1 = {task1}");
}