//
//  ContentView.swift
//  Fractal
//
//  Created by 太田誠司 on 2022/11/03.
//

import SwiftUI

let maxLevel = 17
let shrink = 0.67
let da = 0.7

struct ContentView: View {
	
	
	var body: some View {
		
		return GeometryReader { g in
			
			
			var paths: Path = Path()
			
			plot(paths: &paths, size: g.size)
			
			return Canvas(opaque: true, rendersAsynchronously: false) { context, size in
				
				context.stroke(paths, with: .color(Color.red))
			}
		}
	}
	
	
	func subroutine(paths: inout Path, a: inout Double, l: inout Double, x: inout CGFloat, y: inout CGFloat, level: inout Int, xs: inout [CGFloat], ys: inout [CGFloat]) {
		
		let dx = l * cos(a)
		let dy = l * sin(a)
		let nx = x + dx
		let ny = y - dy
		
		paths.move(to: CGPoint(x: x, y: y))
		paths.addLine(to: CGPoint(x: nx, y: ny))
		
		xs[level] = x
		ys[level] = y
		x = nx
		y = ny
		level = level + 1
		a = a + da
		l = l * shrink
		if level < maxLevel { subroutine(paths: &paths, a: &a, l: &l, x: &x, y: &y, level: &level, xs: &xs, ys: &ys) }
		a = a - da * 2
		if level < maxLevel { subroutine(paths: &paths, a: &a, l: &l, x: &x, y: &y, level: &level, xs: &xs, ys: &ys) }
		a = a + da
		l = l / shrink
		level = level - 1
		x = xs[level]
		y = ys[level]
	}
	
	func plot(paths: inout Path, size: CGSize) {
		var a = 3.14159 * 0.5
		var l: Double = Double(min(size.width, size.height) / 3.5)
		var x = size.width / 2
		var y: CGFloat = size.height
		var level = 0
		var xs: [CGFloat] = Array(repeating: 0, count: maxLevel)
		var ys: [CGFloat] = Array(repeating: 0, count: maxLevel)
		
		subroutine(paths: &paths, a: &a, l: &l, x: &x, y: &y, level: &level, xs: &xs, ys: &ys)
	}
	
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
