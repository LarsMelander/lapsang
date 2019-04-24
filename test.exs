
{:ok, conn} = Lapsang.connect
{:ok, conn} = Lapsang.login(conn, "root", "pass")
{:ok, conn} = Lapsang.db_open(conn, "bdrp")
Lapsang.create_vertex(conn, "V", name: "Apa")
