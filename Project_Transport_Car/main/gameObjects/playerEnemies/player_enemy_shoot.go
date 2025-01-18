components {
  id: "enemy_shoot"
  component: "/main/_scripts/entities/enemy_shoot.script"
  properties {
    id: "speed"
    value: "1000.0"
    type: PROPERTY_TYPE_NUMBER
  }
  properties {
    id: "life"
    value: "1.0"
    type: PROPERTY_TYPE_NUMBER
  }
  properties {
    id: "bulletDamage"
    value: "50.0"
    type: PROPERTY_TYPE_NUMBER
  }
  properties {
    id: "bulletMask"
    value: "player"
    type: PROPERTY_TYPE_HASH
  }
  properties {
    id: "raytraceMask"
    value: "car"
    type: PROPERTY_TYPE_HASH
  }
  properties {
    id: "target"
    value: "/player/player"
    type: PROPERTY_TYPE_HASH
  }
  properties {
    id: "radius"
    value: "500.0"
    type: PROPERTY_TYPE_NUMBER
  }
}
components {
  id: "enemy_bullet"
  component: "/main/factories/enemy_bullet.factory"
}
components {
  id: "health_manager"
  component: "/main/_scripts/entities/health_manager.script"
  properties {
    id: "max_health"
    value: "200.0"
    type: PROPERTY_TYPE_NUMBER
  }
  properties {
    id: "health_type"
    value: "enemy"
    type: PROPERTY_TYPE_HASH
  }
}
components {
  id: "enemyDriveUp"
  component: "/main/_scripts/car_ai/enemyDriveUp.script"
  properties {
    id: "target_x"
    value: "600.0"
    type: PROPERTY_TYPE_NUMBER
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"squarebot\"\n"
  "material: \"/assets/shader/sprite_1.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/atlases/main.atlas\"\n"
  "}\n"
  ""
  position {
    x: -9.0
  }
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
  "  data: 87.8\n"
  "  data: 87.8\n"
  "  data: 87.8\n"
  "}\n"
  ""
}
