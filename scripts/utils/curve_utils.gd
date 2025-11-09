class_name CurveUtils
## Utility functions for working with curves and splines
## Used by the level editor for track smoothing

## Smooth a curve using Catmull-Rom spline
static func smooth_curve_catmull_rom(points: PackedVector3Array, tension: float = 0.5) -> Curve3D:
	var curve = Curve3D.new()

	if points.size() < 2:
		return curve

	for i in range(points.size()):
		var point = points[i]
		curve.add_point(point)

		# Calculate tangents for smooth interpolation
		if i > 0 and i < points.size() - 1:
			var prev = points[i - 1]
			var next = points[i + 1]
			var tangent = (next - prev) * 0.5 * tension

			curve.set_point_in(i, -tangent)
			curve.set_point_out(i, tangent)

	return curve

## Simplify curve by removing redundant points (Douglas-Peucker algorithm)
static func simplify_curve(points: PackedVector3Array, epsilon: float = 0.1) -> PackedVector3Array:
	if points.size() < 3:
		return points

	# Find point with maximum distance from line between first and last point
	var max_distance = 0.0
	var max_index = 0

	var line_start = points[0]
	var line_end = points[points.size() - 1]

	for i in range(1, points.size() - 1):
		var distance = point_to_line_distance(points[i], line_start, line_end)
		if distance > max_distance:
			max_distance = distance
			max_index = i

	# If max distance is greater than epsilon, recursively simplify
	if max_distance > epsilon:
		# Recursive call for first half
		var first_half = points.slice(0, max_index + 1)
		var results1 = simplify_curve(first_half, epsilon)

		# Recursive call for second half
		var second_half = points.slice(max_index, points.size())
		var results2 = simplify_curve(second_half, epsilon)

		# Combine results (remove duplicate point at max_index)
		var combined = PackedVector3Array()
		for p in results1:
			combined.append(p)
		for i in range(1, results2.size()):
			combined.append(results2[i])

		return combined
	else:
		# All points between start and end can be removed
		return PackedVector3Array([line_start, line_end])

## Calculate distance from point to line segment
static func point_to_line_distance(point: Vector3, line_start: Vector3, line_end: Vector3) -> float:
	var line_vec = line_end - line_start
	var point_vec = point - line_start

	var line_length = line_vec.length()
	if line_length < 0.001:
		return point_vec.length()

	var line_dir = line_vec / line_length
	var projection = point_vec.dot(line_dir)

	# Clamp projection to line segment
	projection = clamp(projection, 0.0, line_length)

	var closest_point = line_start + line_dir * projection
	return point.distance_to(closest_point)

## Resample curve to have evenly spaced points
static func resample_curve(curve: Curve3D, num_samples: int) -> PackedVector3Array:
	var points = PackedVector3Array()
	var length = curve.get_baked_length()

	if length < 0.001 or num_samples < 2:
		return points

	for i in range(num_samples):
		var t = float(i) / float(num_samples - 1)
		var distance = t * length
		var point = curve.sample_baked(distance)
		points.append(point)

	return points

## Get tangent at position along curve
static func get_curve_tangent(curve: Curve3D, distance: float) -> Vector3:
	return curve.sample_baked_tangent(distance)

## Get normal (perpendicular to tangent in XZ plane)
static func get_curve_normal(curve: Curve3D, distance: float) -> Vector3:
	var tangent = curve.sample_baked_tangent(distance)
	var up = Vector3.UP
	var normal = tangent.cross(up).normalized()
	return normal
