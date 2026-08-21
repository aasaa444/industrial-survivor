#!/usr/bin/env python3
"""Report import -> loader -> parse layers for one Godot resource."""
from __future__ import annotations
import argparse, json, subprocess
from pathlib import Path

def run(cmd, cwd):
 r=subprocess.run(cmd,cwd=cwd,capture_output=True,text=True,encoding='utf-8',errors='replace');return {"exit":r.returncode,"stdout":r.stdout[-2000:],"stderr":r.stderr[-2000:]}
def main():
 p=argparse.ArgumentParser();p.add_argument('--project-root',type=Path,default=Path.cwd());p.add_argument('--resource',required=True);p.add_argument('--godot',type=Path,required=True);p.add_argument('--dry-run',action='store_true');a=p.parse_args();root=a.project_root.resolve();res=root/a.resource
 out={"project_root":str(root),"resource":a.resource,"resource_exists":res.exists(),"import_sidecar_exists":Path(str(res)+'.import').exists(),"layers":{}}
 if a.dry_run: print(json.dumps(out,indent=2));return
 out['layers']['headless_import']=run([str(a.godot),'--headless','--import','--path',str(root)],root)
 out['layers']['parse']=run([str(a.godot),'--headless','--path',str(root),'--quit-after','3'],root)
 parse_text=out['layers']['parse']['stdout']+'\n'+out['layers']['parse']['stderr']
 out['parse_ok']='Parse Error' not in parse_text and 'SCRIPT ERROR' not in parse_text
 print(json.dumps(out,ensure_ascii=False,indent=2))
 raise SystemExit(0 if out['resource_exists'] and out['parse_ok'] else 2)
if __name__=='__main__':main()
