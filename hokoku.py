#!/usr/bin/python
# -*- coding: utf-8 -*-
from datetime import datetime
from gi.repository import Gtk

class HokokuWindow(Gtk.Window):
    reportto=["公安","CIA","Mossad","ISI","sd先生"]
    reportlbl=["koan","cia","mossad","isi","profsd"]
    def __init__(self):
        Gtk.Window.__init__(self, title="報告ボタン")
        self.set_size_request(300, 100)
        self.timeout_id=None
        
        vbox=Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.add(vbox)
        self.entry=Gtk.Entry()
        vbox.pack_start(self.entry,True,True,0)

        hbox=Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=6)
        
        self.cboxes=[]
        for i in self.reportto:
            cb=Gtk.CheckButton(i)
            hbox.pack_start(cb,True,True,0)
            self.cboxes.append(cb)
        
        self.button = Gtk.Button(label="報告する")
        self.button.connect("clicked", self.on_button_clicked)
        hbox.pack_start(self.button,True,True,0)
        
        vbox.pack_start(hbox,True,True,0)

    def on_button_clicked(self, widget):
        reportd=self.entry.get_text()
        timestamp="["+str(datetime.now())+"] "
        reportt=timestamp+reportd+"\n"
        for i, cb in enumerate(self.cboxes):
            if cb.get_active():
                filename=self.reportlbl[i]+".txt"
                f=open(filename,'a')
                f.write(reportt)
                f.close()
        self.entry.set_text("")

win = HokokuWindow()
win.connect("delete-event", Gtk.main_quit)
win.show_all()
Gtk.main()
