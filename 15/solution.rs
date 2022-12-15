use std::io;

#[derive(Debug)]
struct Line
{
    offset: i64,
//    y1: i64,
//    y2: i64,
}

fn add_line(lines:&mut Vec<Line>, data:&Vec<i64>, direction: i64)
{
    let distance = (data[0] - data[2]).abs() + (data[1] - data[3]).abs();
    lines.push(Line{
        offset: data[0] - direction*(data[1] - distance),
//        y1: data[1] - distance,
//        y2: data[1],
    });
    lines.push(Line{
        offset: data[0] - direction*(data[1] + distance),
//        y1: data[1],
//        y2: data[1] + distance,
    });
}

fn find_solution(f: &Line, b: &Line)
{
    let o1 = f.offset + 1;
    let o2 = b.offset + 1;
    let y = (o2 - o1) / 2;
    let x = o1 + y;
    let task2 = 4000000 * x + y;
    println!("{x} {y}");
    println!("task2 = {task2}")
}

fn main()
{
    let re = regex::Regex::new(r"-?\d+").unwrap();
    let mut flines: Vec<Line> = Vec::new();
    let mut blines: Vec<Line> = Vec::new();
	for line in io::stdin().lines()
	{
        let vec: Vec<i64> = re.find_iter(&line.unwrap()).map(|s| s.as_str().parse().unwrap()).collect();
        add_line(&mut flines, &vec, 1);
        add_line(&mut blines, &vec, -1);
	}
    let key = |a:&Line, b:&Line| a.offset.cmp(&b.offset);
    flines.sort_unstable_by(key);
    blines.sort_unstable_by(key);

    for i in 2..flines.len()
    {
        if flines[i].offset - flines[i-1].offset == 2
        {
            for j in 2..blines.len()
            {
                if blines[j].offset - blines[j-1].offset == 2
                {
                    find_solution(&flines[i-1], &blines[j-1]);
                }
            }
        }
    }
}
