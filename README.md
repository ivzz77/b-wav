# bullets over soundwaves
pvp danmaku game inspired by maiden &amp; spell with music based elements
magical's rewrite of the month old vfx branch...

## rollback
* combination of what was originally in the [vfx branch](https://github.com/ivzz77/b-wav/tree/vfx) and our current architecture in [merge test](https://github.com/ivzz77/b-wav/tree/merge-test)
* physics engine implementation is in [World]

## changes
* added more functionality to the physics engine abstract class
    * so, added spawn_attack (optimized collection of bullets, best for already predetermined paths)
    * spawn_bullet (general path, bullets whose state depends on the previous physics state)
    * query_bullets (used to get bullet positions in bulk)
* also didn't really have any use for getting positions of individual bullets (because of the bulk operation), so that's omitted from the physics engine

## findings
* interpolator logic doesnt really matter now since player rollback does that interpolation for you lol
* added a bit more to the physics engine abstract class
    * added spawn_attack (optimized collection of bullets)
    * added query

## todos
* implement the rest of the game logic + communication layer stuff, need to hook up the backend from merge-test though.
