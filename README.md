# XP Ranks

An `xp_redo` companion mod with a long-term rank progression and configurable,
cumulative rank privileges.

## Rank thresholds

- Newcomer: 0, 100, 200, 300, 500, 700 XP
- Inhabitant: 1,000, 2,500, 5,000, 10,000, 25,000, 50,000, 75,000 XP
- Citizen: 100,000, 200,000, 350,000, 500,000, 700,000, 900,000, 1,100,000 XP
- Noble: 1,200,000 XP

## Privilege configuration

Privileges are comma- or whitespace-separated and cumulative. Example:

```ini
xp_ranks.privileges.newcomer =
xp_ranks.privileges.inhabitant = home
xp_ranks.privileges.citizen = fast
xp_ranks.privileges.noble = fly
```

With this example, a Noble receives `home`, `fast`, and `fly`.

By default, XP loss never revokes privileges. Optional revocation can be enabled:

```ini
xp_ranks.revoke_on_demotion = true
```

Only privileges previously added and tracked by this mod are candidates for
revocation. Existing unrelated privileges are preserved.

## Installation

Install this directory as `xp_ranks`, enable it for the world, and restart the
server:

```ini
load_mod_xp_ranks = true
```

