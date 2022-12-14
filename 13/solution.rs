use std::io;
use std::str;
use std::cmp::min;
use serde_json::{Value,to_value};


/*
 * First of all, boring solution by exploiting JSON parser
 */
fn jsoncompare(a: &Value, b: &Value) -> Option<bool>
{
	if a.is_i64() && b.is_i64()
	{
		let x = a.as_i64().unwrap();
		let y = b.as_i64().unwrap();
		return if x == y {None} else {Some(x < y)};
	}
	if a.is_array() && b.is_array()
	{
		let x = a.as_array().unwrap();
		let y = b.as_array().unwrap();
		for i in 0..min(x.len(), y.len())
		{
			let r = jsoncompare(&x[i], &y[i]);
			if r.is_some()
			{
				return r;
			}
		}
		if x.len() != y.len()
		{
			return Some(x.len() < y.len());
		}
	}
	else if !a.is_array()
	{
		let x = to_value(vec![a]).unwrap();
		return jsoncompare(&x, b);
	}
	else if !b.is_array()
	{
		let x = to_value(vec![b]).unwrap();
		return jsoncompare(a, &x);
	}
	return None;
}

fn compare(a: &[u8], b: &[u8]) -> bool
{
	let first = serde_json::from_str(str::from_utf8(a).unwrap()).unwrap();
	let second = serde_json::from_str(str::from_utf8(b).unwrap()).unwrap();
	return jsoncompare(&first, &second).unwrap();
}

/*
 * Way more complicated solution, but at least no parsing.
 */
fn compare2(a: &[u8], b: &[u8]) -> bool
{
	let mut i: usize = 0;
	let mut j: usize = 0;
	let mut length = vec![];
	let mut aw = vec![];
	let mut bw = vec![];
	
	macro_rules! open {
		($x:expr, $y:expr) => {
			length.push(1);
			aw.push($x);
			bw.push($y);
		}
	}
	macro_rules! close {
		() => {
			length.pop();
			aw.pop();
			bw.pop();
		}
	}
	macro_rules! check {
		($d:expr, $w:expr, $ret:expr) => {
			if $w.last().unwrap() != &-1 && $d.last().unwrap() > $w.last().unwrap()
			{
				return $ret;
			}
		};
		($w:expr, $ret:expr) => {
			if $w.last().unwrap() == &-1
			{
				return $ret;
			}
		}
	}
	
	while i < a.len() && j < b.len()
	{
		match (a[i], b[j])
		{
			(b',', b',') => {
				*length.last_mut().unwrap()+=1;
				check!(length, aw, true);
				check!(length, bw, false);
			}
			(b'[', b'[') => {open!(-1,-1);}
			(b']', b']') => {close!();}
			(b'[', b']') => {return false;} /* i think so, but i am not sure */
			(b']', b'[') => {return true;}  /* same */
			(x, y) if x == y => {}
			(b'[',_) => {open!(-1,1); i += 1; continue}
			(_,b'[') => {open!(1,-1); j += 1; continue}
			(b']',_) => {check!(bw, true); close!(); i += 1; continue}
			(_,b']') => {check!(aw, false); close!(); j += 1; continue}
			(x, y) => {return x < y}
		}

		i += 1;
		j += 1;
	}
	return a.len() < b.len();
}

fn main()
{
	let mut it = io::stdin().lines();
	let mut task1 = 0;
	for i in 1..10000
	{
		let line1 = it.next().unwrap().unwrap();
		let line2 = it.next().unwrap().unwrap();
		let r = compare(line1.as_bytes(), line2.as_bytes());
		// "10" -> "a" is ugly hack, since my compare2() assumes that all numbers have the same length.
		// It works because '9' < 'a', so comparisons work out.
		let r2 = compare2(line1.replace("10","a").as_bytes(), line2.replace("10","a").as_bytes());
		if r != r2
		{
			println!("mismatch for {i} : {r}/{r2}");
			std::process::exit(1);
		}
		if r
		{
			task1 += i;
		}
		if it.next().is_none()
		{
			break;
		}
	}
	println!("task1 = {task1} ({})", task1 == 6076);
}

