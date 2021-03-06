-- Copyright (C) 2007, 2010 - Bit-Blot
--
-- This file is part of Aquaria.
--
-- Aquaria is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--
-- See the GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

if not v then v = {} end
if not AQUARIA_VERSION then dofile("scripts/entities/entityinclude.lua") end

v.n = 0

v.bubbleSpawnDelay = 2.5
v.bubbleSpawnTimer = v.bubbleSpawnDelay

v.mouth = 0

function init(me)
	setupEntity(me)
	entity_setEntityType(me, ET_ENEMY)
	entity_initSkeletal(me, "beluga")	
	
	entity_setCollideRadius(me, 32)
	--entity_setAllDamageTargets(me, false)
	
	entity_setState(me, STATE_IDLE)
	
	v.mouth = entity_getBoneByName(me, "mouth")
	
	entity_addVel(me, randVector(300))
	
	entity_setMaxSpeed(me, 100)
	
	entity_setDeathParticleEffect(me, "tinyblueexplode")
	
	entity_setDamageTarget(me, DT_AVATAR_LIZAP, false)
	entity_setDamageTarget(me, DT_AVATAR_PET, false)
end

function postInit(me)
	v.n = getNaija()
	entity_setTarget(me, v.n)
end

function update(me, dt)
	entity_updateMovement(me, dt)
	
	entity_doCollisionAvoidance(me, dt, 8, 1)
	
	entity_handleShotCollisions(me)
	
	entity_flipToVel(me)
	
	v.bubbleSpawnTimer = v.bubbleSpawnTimer - dt
	
	if v.bubbleSpawnTimer < 0 then
		local bx,by = bone_getWorldPosition(v.mouth)
		local bb = createEntity("beluga-bubble", "", bx, by)
		entity_animate(me, "blowbubble", 0, 1)
		v.bubbleSpawnTimer = v.bubbleSpawnDelay
		entity_addVel(bb, entity_velx(me)*0.5, entity_vely(me)*0.5)
		entity_scale(bb, 0, 0)
		entity_scale(bb, 1, 1, 1)
	end
end

function enterState(me)
	if entity_isState(me, STATE_IDLE) then
		entity_animate(me, "idle", -1)
	end
end

function exitState(me)
end

function damage(me, attacker, bone, damageType, dmg)
	return true
end

function animationKey(me, key)
end

function hitSurface(me)
end

function songNote(me, note)
end

function songNoteDone(me, note)
end

function song(me, song)
end

function activate(me)
end

