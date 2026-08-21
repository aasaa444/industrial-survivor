#!/usr/bin/env python3
"""Validate ordered runtime transaction evidence against an integration contract."""
from __future__ import annotations
import argparse, hashlib, json, sys
from pathlib import Path
REQUIRED=["trigger","mutate","read_model","behavior","feedback","reset"]
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--contract',type=Path,required=True);ap.add_argument('--evidence',type=Path,required=True);ap.add_argument('--dry-run',action='store_true');a=ap.parse_args()
 c=json.loads(a.contract.read_text(encoding='utf-8')); lines=[]
 for raw in a.evidence.read_text(encoding='utf-8').splitlines():
  if raw.strip(): lines.append(json.loads(raw))
 if a.dry_run:
  print(json.dumps({'schema_version':'runtime-verifier-v1','status':'dry_run','contract_id':c.get('contract_id'),'required_steps':REQUIRED,'evidence_path':str(a.evidence.resolve()),'will_mutate_project':False},ensure_ascii=False,indent=2));return 0
 errors=[];seen=[];base_sha=c.get('git_sha');base_root=c.get('project_root');tx=None;last=-1
 for i,row in enumerate(lines,1):
  if row.get('schema_version')!='runtime-transaction-evidence-v1':errors.append(f'line {i}: schema mismatch')
  if row.get('contract_id')!=c.get('contract_id'):errors.append(f'line {i}: contract mismatch')
  if base_sha and row.get('git_sha')!=base_sha:errors.append(f'line {i}: git_sha mismatch')
  if base_root and row.get('project_root')!=base_root:errors.append(f'line {i}: project_root mismatch')
  if tx is None:tx=row.get('transaction_id')
  if row.get('transaction_id')!=tx:errors.append(f'line {i}: transaction_id mismatch')
  seq=row.get('sequence',-1)
  if not isinstance(seq,int) or seq<=last:errors.append(f'line {i}: sequence not increasing')
  last=seq;step=row.get('step_id');seen.append(step)
  for field in ['observed_at','tick','action','state_delta','event_refs','log_refs','artifact_refs','evidence_boundary']:
   if field not in row:errors.append(f'line {i}: missing {field}')
  if row.get('status')!='passed':errors.append(f'line {i}: status not passed')
 if seen!=REQUIRED:errors.append(f'steps must be {REQUIRED}, got {seen}')
 result={'schema_version':'runtime-verifier-v1','contract_id':c.get('contract_id'),'status':'failed' if errors else 'passed','passed_steps':[] if errors else REQUIRED,'missing_steps':[x for x in REQUIRED if x not in seen],'errors':errors,'evidence_boundary':'exact ordered runtime transaction only; visual/user acceptance separate','exit_code':2 if errors else 0}
 print(json.dumps(result,ensure_ascii=False,indent=2));return result['exit_code']
if __name__=='__main__':raise SystemExit(main())
