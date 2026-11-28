class_name KatPrimary
extends RefCounted

const BULLET_LIFETIME : float = 4.0
const CLAW_FORWARD_SPEEDS : Array[float] = [480.0, 545.0, 650.0]
const CLAW_KINDS : Array[BulletKind.BulletKind] = [
	BulletKind.BulletKind.CLAW_1,
	BulletKind.BulletKind.CLAW_2,
	BulletKind.BulletKind.CLAW_3,
]


static func build_pattern() -> BulletCommandPool:
	var pattern := BulletCommandPool.new()
	for depth in range(CLAW_FORWARD_SPEEDS.size()):
		for lane_index in range(3):
			var lane := float(lane_index - 1)
			var origin := Vector2(float(depth) * 24.0, lane * 28.0)
			var velocity := Vector2(
				CLAW_FORWARD_SPEEDS[depth],
				lane * (10.0 + float(depth) * 12.0)
			)
			pattern.summon(CLAW_KINDS[depth], BULLET_LIFETIME, Piecewise.pv(origin, velocity))

	return pattern.commit()
