# TPZ-CORE Base

# About

The specified Framework has been created by @Nosmakos.

All the official resources that have been shared to the public,
are very well made, fully configurable, including webhooks and most importantly,
they all have DevTools - Injection Cheating Protections.
 
# Repositories

You can find all of our repositories [here](https://github.com/TPZ-CORE?tab=repositories)
# Development API

Checkout the official website - [Gitbook](https://tpz-core.gitbook.io/tpz-core-documentation) 
to use our Framework on your scripts.

We provide all the functions related to the player object, player inventory, utility functions
such as webhooks, notifications and many more, including all the commands related to our official shared resources.

## Commands

- @param [source] : The online Player ID. 

| Command                                    | Ace Permission        | Description                                                              | Console / TXAdmin Console Support |
|--------------------------------------------|-----------------------|--------------------------------------------------------------------------|-----------------------------------|
| setmaxchars [source] [chars]               | tpzcore.setmaxchars   | Sets the selected player source the total maximum characters to create.  | Yes |
| setinventoryweight [source] [weight]        | tpzcore.setinventoryweight | Sets the maximum inventory weight capacity of the selected user.   | Yes |
| addinventoryweight [source] [weight]        | tpzcore.addinventoryweight | Adds extra inventory weight capacity on the selected user.         | Yes |
| setgroup [source] [group]                   | tpzcore.setgroup        | Sets the selected player source group role (admin, mod, etc).         | Yes |
| setjob [source] [job] [grade]              | tpzcore.setjob        | Sets the selected player source job and grade.                           | Yes |
| addaccount [source] [account] [amount]     | tpzcore.addaccount    | Adds an amount of money (account) to the selected player source.         | Yes |
| removeaccount [source] [account] [amount]  | tpzcore.removeaccount | Removes an amount of money (account) from the selected player source.    | Yes |
| revive [source]                            | tpzcore.revive        | Revives an unconcious (dead) player source.                              | Yes |
| kill [source]                              | tpzcore.kill          | Kills the selected player source.                                        | Yes |
| heal [source]                              | tpzcore.heal          | Heals the selected player source (including tpz_metabolism values).      | Yes |
| tpcoords [x] [y] [z]                       | tpzcore.tpcoords      | Teleports your player to the specific coords (x,y,z).                    | No |
| tpto [source]                              | tpzcore.tpto          | Teleports your player to the selected player source.                     | No |
| tphere [source]                            | tpzcore.tphere        | Brings the selected player source to your player.                        | No |
| tpm                                         | tpzcore.tpm          | Teleports your player to the selected marked map point.                  | No |
| id                                         | n/a                   | Displays your player character online source ID through a notification.  | No |
| job                                         | n/a          | Displays your player character job and job grade through a notification.         | No |

- The ace permission: `tpzcore.all` Gives permissions to all commands and actions (FOR ALL OFFICIAL PUBLISHED FREE SCRIPTS).

- All the commands and descriptions and permissions are fully configurable.

## Webhooks

You want your webhooks to be fully-protected by DevTools or Injections? You better checkout `server\tp-server_webhooks.lua` file which allows you to add webhooks and get them through the API (`TPZ.GetWebhookUrl(webhook)`) for using them to other scripts. 
## Support

For more information and support related to our Framework you can contact us on our discord: https://discord.gg/Ms7TR9VsAB

## Disclaimer and Credits

Credits to VORP-CORE for the logic of Server & Client Callbacks, Notifications and to REDEM:RP for useful native and clothing functions.


