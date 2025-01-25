components {
  id: "health_manager"
  component: "/main/_scripts/entities/health_manager.script"
  properties {
    id: "max_health"
    value: "100.0"
    type: PROPERTY_TYPE_NUMBER
  }
  properties {
    id: "health_type"
    value: "enemy"
    type: PROPERTY_TYPE_HASH
  }
}
components {
  id: "surround_player"
  component: "/main/_scripts/car_ai/TEST_Car_Behaviors/surround_player.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"minibot1\"\n"
  "material: \"/assets/shader/sprite_1.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/atlases/main.atlas\"\n"
  "}\n"
  ""
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_TRIGGER\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"enemy\"\n"
  "mask: \"playerBullet\"\n"
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
  "  data: 94.6\n"
  "  data: 94.6\n"
  "  data: 94.6\n"
  "}\n"
  ""
}
