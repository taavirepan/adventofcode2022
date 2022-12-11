use std::io;
use std::io::Read;
use std::convert::TryInto;
use std::convert::TryFrom;

fn main()
{
    let mut data = String::new();
    io::stdin().read_to_string(&mut data).unwrap();
	let numbers = data.split_ascii_whitespace().map(|x| x.parse::<i32>());
    let mut x: i32 = 1;
    let mut task1 = 0;
    let mut task2 = ['.'; 40*6];
    for (n, number) in numbers.enumerate()
    {
        let i:i32 = (n + 1).try_into().unwrap();
        let sx = n % 40;
        let sy = n / 40;
        if i32::try_from(sx).unwrap() <= x + 1 && x <= i32::try_from(sx + 1).unwrap()
        {
            task2[sx + sy*40] = '#';
        }
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
    for i in 0..6
    {
        println!("{}", task2[i*40..(i+1)*40].iter().collect::<String>());
    }
}