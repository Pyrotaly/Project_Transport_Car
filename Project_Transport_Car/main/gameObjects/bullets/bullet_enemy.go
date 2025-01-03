components {
  id: "bullet"
  component: "/main/_scripts/bullet.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"missile\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/atlases/main.atlas\"\n"
  "}\n"
  ""
  position {
    x: -15.0
    y: 6.0
  }
  scale {
    x: 0.132
    y: 0.132
    z: 0.132
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_TRIGGER\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"enemyBullet\"\n"
  "mask: \"player\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_BOX\n"
  "    position {\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 3\n"
  "  }\n"
  "  data: 30.110048\n"
  "  data: 10.0\n"
  "  data: 10.0\n"
  "}\n"
  "bullet: true\n"
  ""
}
