use std::io;

fn main()
{
	let mut numbers = vec![0];
	for line in io::stdin().lines()
	{
		let n = numbers.len();
		match line.unwrap().parse::<i32>()
		{
			Ok(i) => numbers[n-1] += i,
			Err(_) => numbers.push(0),
		}
	}
	numbers.sort();
	numbers.reverse();
	let task1 = numbers.iter().max().unwrap();
	let task2: i32 = numbers[0..3].iter().sum();
	println!("{task1}");
	println!("{task2}");
}