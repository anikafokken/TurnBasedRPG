package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.sound.FlxSound;

using flixel.util.FlxSpriteUtil;

enum EnemyType
{
    REGULAR;
    BOSS;
}

class Enemy extends FlxSprite
{
    static inline var WALK_SPEED:Float = 40;
    static inline var CHASE_SPEED:Float = 70;

    public var type:EnemyType;

    var brain:FSM;
    var idleTimer:Float;
    var moveDirection:Float;
    public var seesPlayer:Bool;
    public var playerPosition:FlxPoint;

    var stepSound:FlxSound;

	public function new(x:Float = 0, y:Float = 0, type)
	{
		// draw player
		super(x, y);
        this.type = type;
        var graphic = if (type == BOSS) AssetPaths.boss__png else AssetPaths.enemy__png;
		loadGraphic(graphic, true, 16, 16);
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);

		animation.add("d_idle", [0]);
		animation.add("lr_idle", [3]);
		animation.add("u_idle", [6]);
		animation.add("d_walk", [0, 1, 0, 2], 6);
		animation.add("lr_walk", [3, 4, 3, 5], 6);
		animation.add("u_walk", [6, 7, 6, 8], 6);

		drag.x = drag.y = 10;

		setSize(8, 8);
		offset.x = 4;
        offset.y = 8;

        brain = new FSM(idle);
        idleTimer = 0;
        playerPosition = FlxPoint.get();

        stepSound = FlxG.sound.load(AssetPaths.step__wav, 0.4);
        stepSound.proximity(x, y, FlxG.camera.target, FlxG.width * 0.6);
	}

    override public function update(elapsed:Float)
    {
        if (this.isFlickering())
            return;
        
        var action = "idle";
        if (velocity.x != 0 || velocity.y != 0)
        {
            action = "walk";

            stepSound.setPosition(x + frameWidth / 2, y + height);
            stepSound.play();

            if (Math.abs(velocity.x) > Math.abs(velocity.y))
            {
                if (velocity.x < 0)
                    facing = LEFT;
                else
                    facing = RIGHT;
            }
            else
            {
                if (velocity.y < 0)
                    facing = UP;
                else
                    facing = DOWN;
            }
        }

        switch (facing)
		{
			case LEFT, RIGHT:
				animation.play("lr_" + action);
			case UP:
				animation.play("u_" + action);
			case DOWN:
				animation.play("d_" + action);
			case _:
		}

        
        brain.update(elapsed);
        super.update(elapsed);
    }

    function idle(elapsed:Float)
    {
        if (seesPlayer)
        {
            brain.activeState = chase;
        }
        else if (idleTimer <= 0)
        {
            // 95% chance to move
            if (FlxG.random.bool(95))
            {
                moveDirection = FlxG.random.int(0, 8) * 45;

                velocity.setPolarDegrees(WALK_SPEED, moveDirection);
            }
            else
            {
                moveDirection = -1;
                velocity.x = velocity.y = 0;
            }
            idleTimer = FlxG.random.int(1, 4);
        }
    }

    function chase(elapsed:Float)
    {
        if (!seesPlayer)
        {
            brain.activeState = idle;
        }
        else
        {
            FlxVelocity.moveTowardsPoint(this, playerPosition, CHASE_SPEED);
        }
    }

    public function changeType(type:EnemyType)
    {
        if (this.type != type)
        {
            this.type = type;
            var graphic = if (type == BOSS) AssetPaths.boss__png else AssetPaths.enemy__png;
            loadGraphic(graphic, true, 16, 16);
        }
    }

}
