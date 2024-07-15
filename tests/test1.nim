import temple, std/tables

echo templateify(
  """
$if(exists_and_full)$
<p>$exists_and_full$</p>
$end$

$if(!exists_and_full)$
<p>I shouldn't be running! A</p>
$end$
  """,
  {"exists_and_full": "Hi! I exist and I am full!"}.toTable
)
echo templateify(
  """
$if(exists_and_not_full)$
<p>I shouldn't be running! B</p>
$end$

$if(!exists_and_not_full)$
<p>Helo! I should be running!</p>
$end$
  """,
  {"exists_and_not_full": ""}.toTable
)

echo templateify(
  """
$if(doesnt_exist)$
<p>I shouldn't be running! C</p>
$end$

$if(!doesnt_exist)$
<p>Helo! I should be running! C</p>
$end$
  """,
  initTable[string,string]()
)


echo templateify(
  "<h1>$name$</h1>",
  {"name":"John"}.toTable
)

echo templateify(
  """
$if(enabled)$
$if(result)$
<h1>$result$</h1>
$end$
$end$

$if(!enabled)$
<h2>Help</h2>
$end$
  """,
  {
    "result":"John",
    "enabled":"true",
  }.toTable
)


echo templateify("""
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>$name$</title>
        <link rel="stylesheet" href="/static/style.css">
    </head>
    <body>
        <div id="burrito">
            <header>
                <nav>
                    <a href="/">Home</a>
                    <a href="/about/">About</a>
                    <a href="/auth/sign_up/">Register</a>
                    <a href="/auth/sign_in/">Login</a>
                    $if(login)$
                    <a href="/auth/logout/">Logout</a>
                    $end$
                </nav>
            </header>
            <main>
                <h1>$name[span_separated]$</h1>
                <h2>About this instance</h2>
                <em>$description$</em>
                <h2>What is this?</h2>
                <p>This is the homepage for a website running the Pothole server program. Pothole is a program that creates a social media network when you run it! Pothole is free and open-source, so anyone can create their own social media network, with full control over it. The benefits of this approach are endless but here is a small list:</p>
                <ol>
                    <li>Privacy: All your data is in your hands, and not in the hands of some Big Tech conglomerate that will eventually get leaked. (Examples include: <a href="https://www.wired.com/story/twitter-leak-200-million-user-email-addresses/">Twitter</a>, <a href="https://www.androidpolice.com/google-leak-data-privacy-breach/">Google</a>, <a href="https://en.wikipedia.org/wiki/Facebook%E2%80%93Cambridge_Analytica_data_scandal">Facebook/Meta</a>, but these examples usually get old quite quickly)</li>
                    <li>Freedom: You're free to run your own instance, however you wish. But remember: <a href="https://github.com/penguinite/pothole/blob/d22fd8ca67196fc2d1483eaee7b0c6f727200807/LICENSE#L587">the Pothole developers are in <b>no way</b> liable for any damages whatsoever.</a></li>
                    <li>Lightweightedness: Pothole is designed to consume as little resources as possible, which means you can host this on any old device you have, as long as it can run the database server needed.</li>
                    <li>Community: You can self-host Pothole for a group of friends, family or any other form of community. Which ceates interactions that are more social.</li>
                    <li>Algorithm-free: Many social media sites employ Algorithms, these sadly distract you, make your interactions less social and they make you only think about engagement. Here, there is no algorithm, which means freedom from all those terrible things.</li>
                    $if(federated)$
                    <li>Reliability: Since the network is divided into many smaller servers, each one separate from another, it means that there is way less of a chance that there will be a huge, disastrous outage, like with <a href="https://en.wikipedia.org/wiki/2021_Facebook_outage">the 2021 facebook outage</a></li>
                    $end$
                </ol>
                <p>In here, you can register an account, launch any <a href="https://joinmastodon.org/apps">Mastodon client</a> you want and get started chatting with others. Pothole is microblogging, done the right way.</p>
                $if(federated)$
                <p>It's also possible to talk to other Fediverse servers, as this specific server is configured to federate with other serves. Which means users on entirely different websites can talk with you and vice-versa. This server is a part of the fediverse.</p>
                <h2>What's the fediverse?</h2>
                <p>The fediverse is a growing collection of servers all running programs that can interoperate with each other. What this means is that if you have an account here, then you can talk to others on different websites, without having to make an account there as well.</p>
                $end$
                <footer>
                    $if(version)$
                    <p>This server is powered by <a href="$source$">Pothole</a> $version$</p>
                    $end$
                </footer>
            </main>
        </div>
    </body>
</html>
""", { "name": "John's Example",
  "description": "John Smith's personal Pothole instance for communication with nerds worldwide.",
  "federated": "true",
  "source": "penguinite/pothole.git",
  "version": "38.23.59.3.02.1"
}.toTable
)