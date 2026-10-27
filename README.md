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
xp_ranks.privileges.inhabitant = area_protect
xp_ranks.privileges.citizen = fast
xp_ranks.privileges.noble = fly
```

With this example, a Noble receives `area_protect`, `fast`, and `fly`.
`area_protect` is registered by this mod and is the default privilege granted
from Inhabitant onwards.

To let holders of this privilege create their own protected areas, configure
the `areas` mod in `server.conf`:

```ini
areas.self_protection = true
areas.self_protection_privilege = area_protect
```

This permits `/protect` within the size and count limits configured by
`areas`. It deliberately does not grant the powerful `areas` administrator
privilege. Existing worlds may already have an explicit
`xp_ranks.privileges.inhabitant` setting; add `area_protect` to that value in
this case because explicit settings override the default.

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
