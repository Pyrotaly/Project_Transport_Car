components {
  id: "enemy_shoot"
  component: "/main/_scripts/enemy_ai/enemy_shoot.script"
  properties {
    id: "speed"
    value: "1000.0"
    type: PROPERTY_TYPE_NUMBER
  }
  properties {
    id: "life"
    value: "2.5"
    type: PROPERTY_TYPE_NUMBER
  }
  properties {
    id: "bulletDamage"
    value: "20.0"
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
    value: "2500.0"
    type: PROPERTY_TYPE_NUMBER
  }
  properties {
    id: "shootingMode"
    value: "machine_gun"
    type: PROPERTY_TYPE_HASH
  }
}
components {
  id: "enemy_bullet"
  component: "/main/factories/normal_bullet.factory"
}
components {
  id: "health_manager"
  component: "/main/_scripts/entities/health_manager.script"
  properties {
    id: "max_health"
    value: "3000.0"
    type: PROPERTY_TYPE_NUMBER
  }
  properties {
    id: "health_type"
    value: "enemy"
    type: PROPERTY_TYPE_HASH
  }
}
components {
  id: "truck_ai"
  component: "/main/_scripts/car_ai/truck_ai.script"
}
components {
  id: "enemy_explosion"
  component: "/assets/soundFX/1_zone/enemy_explosion.wav"
}
components {
  id: "bombExplosion"
  component: "/main/particleFX/bombExplosion.particlefx"
  position {
    x: 192.0
  }
}
components {
  id: "car_collision"
  component: "/assets/soundFX/Audio/car/car_collision.wav"
}
components {
  id: "projecty_audio"
  component: "/assets/soundFX/Audio/gun_shot/projecty_audio.wav"
}
components {
  id: "car_collision1"
  component: "/assets/soundFX/Audio/car/car_collision.wav"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"truck\"\n"
  "material: \"/assets/shader/sprite_1.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/atlases/final_atlas.atlas\"\n"
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
  "  data: 298.84003\n"
  "  data: 147.95029\n"
  "  data: 87.8\n"
  "}\n"
  ""
}
