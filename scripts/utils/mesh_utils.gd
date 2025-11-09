class_name MeshUtils
## Utility functions for runtime mesh generation
## Used by level editor for creating track meshes

## Create a mesh by extruding a polygon along a path
static func extrude_polygon_along_path(polygon: PackedVector2Array, path: Curve3D, segments: int = 100) -> ArrayMesh:
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)

	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	var normals = PackedVector3Array()
	var uvs = PackedVector2Array()

	var path_length = path.get_baked_length()

	# Generate vertices along path
	for i in range(segments + 1):
		var t = float(i) / float(segments)
		var distance = t * path_length

		# Get position and orientation at this point on path
		var position = path.sample_baked(distance)
		var forward = path.sample_baked_tangent(distance)
		var right = forward.cross(Vector3.UP).normalized()
		var up = right.cross(forward).normalized()

		# Create transform for this cross-section
		var basis = Basis(right, up, forward)

		# Add vertices for this cross-section
		for j in range(polygon.size()):
			var poly_point = polygon[j]
			var vertex = position + basis * Vector3(poly_point.x, poly_point.y, 0)
			vertices.append(vertex)

			# Normal points up (simplified)
			normals.append(up)

			# UV coordinates
			uvs.append(Vector2(float(j) / float(polygon.size()), t))

	# Generate indices for triangles
	var verts_per_section = polygon.size()
	for i in range(segments):
		for j in range(verts_per_section):
			var next_j = (j + 1) % verts_per_section

			var current_base = i * verts_per_section
			var next_base = (i + 1) * verts_per_section

			# First triangle
			indices.append(current_base + j)
			indices.append(next_base + j)
			indices.append(current_base + next_j)

			# Second triangle
			indices.append(current_base + next_j)
			indices.append(next_base + j)
			indices.append(next_base + next_j)

	# Set arrays
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_TEX_UV] = uvs

	# Create mesh
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	return mesh

## Create a simple box mesh
static func create_box_mesh(size: Vector3) -> ArrayMesh:
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)

	var half = size / 2.0

	var vertices = PackedVector3Array([
		# Front face
		Vector3(-half.x, -half.y, half.z), Vector3(half.x, -half.y, half.z),
		Vector3(half.x, half.y, half.z), Vector3(-half.x, half.y, half.z),
		# Back face
		Vector3(half.x, -half.y, -half.z), Vector3(-half.x, -half.y, -half.z),
		Vector3(-half.x, half.y, -half.z), Vector3(half.x, half.y, -half.z),
		# Top face
		Vector3(-half.x, half.y, half.z), Vector3(half.x, half.y, half.z),
		Vector3(half.x, half.y, -half.z), Vector3(-half.x, half.y, -half.z),
		# Bottom face
		Vector3(-half.x, -half.y, -half.z), Vector3(half.x, -half.y, -half.z),
		Vector3(half.x, -half.y, half.z), Vector3(-half.x, -half.y, half.z),
		# Right face
		Vector3(half.x, -half.y, half.z), Vector3(half.x, -half.y, -half.z),
		Vector3(half.x, half.y, -half.z), Vector3(half.x, half.y, half.z),
		# Left face
		Vector3(-half.x, -half.y, -half.z), Vector3(-half.x, -half.y, half.z),
		Vector3(-half.x, half.y, half.z), Vector3(-half.x, half.y, -half.z)
	])

	var indices = PackedInt32Array([
		0, 1, 2, 0, 2, 3,  # Front
		4, 5, 6, 4, 6, 7,  # Back
		8, 9, 10, 8, 10, 11,  # Top
		12, 13, 14, 12, 14, 15,  # Bottom
		16, 17, 18, 16, 18, 19,  # Right
		20, 21, 22, 20, 22, 23   # Left
	])

	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices

	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	return mesh

## Create collision shape from mesh
static func create_trimesh_collision(mesh: Mesh) -> ConcavePolygonShape3D:
	var shape = mesh.create_trimesh_shape()
	return shape

## Calculate mesh bounds
static func get_mesh_bounds(mesh: Mesh) -> AABB:
	if mesh.get_surface_count() == 0:
		return AABB()

	var arrays = mesh.surface_get_arrays(0)
	var vertices = arrays[Mesh.ARRAY_VERTEX] as PackedVector3Array

	if vertices.size() == 0:
		return AABB()

	var min_point = vertices[0]
	var max_point = vertices[0]

	for vertex in vertices:
		min_point.x = min(min_point.x, vertex.x)
		min_point.y = min(min_point.y, vertex.y)
		min_point.z = min(min_point.z, vertex.z)

		max_point.x = max(max_point.x, vertex.x)
		max_point.y = max(max_point.y, vertex.y)
		max_point.z = max(max_point.z, vertex.z)

	return AABB(min_point, max_point - min_point)
