function setup_coapcp_server(settings)
   -- server to emulate scp
   ccp = coap.Server()
   ccp:listen(3000)
   function cp(data)
      i = 1
      j = 3
      while string.sub(data,i,j) ~= ":::" do
         i = i + 1
         j = j + 1
      end
      filename = string.sub(data,1, i - 1)
      print(filename)
      file.open(filename, 'w+')
      file.write(string.sub(data, j+1, string.len(data)))
      file.close()
      return "thanks"
   end
   ccp:func("cp")
end

setup_coapcp_server()
