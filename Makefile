%.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(FPIC) -c -o $@ $<

clean:
	rm -f probe_data_post *.o

probe_data_post: probe_data_post.o
	$(CC) $(LDFLAGS) -o $@ $^ -ldl

compile: probe_data_post

install: compile
	mkdir -p $(DESTDIR)/usr/sbin
	cp probe_data_post $(DESTDIR)/usr/sbin/probe_data_post
	cp post_mac_probe.sh  $(DESTDIR)/usr/sbin/post_mac_probe
