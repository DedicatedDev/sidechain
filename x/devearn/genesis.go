package devearn

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"sidechain/x/devearn/keeper"
	"sidechain/x/devearn/types"
)

// InitGenesis initializes the module's state from a provided genesis state.
func InitGenesis(ctx sdk.Context, k keeper.Keeper, genState types.GenesisState) {
	// this line is used by starport scaffolding # genesis/module/init
	k.SetParams(ctx, genState.Params)
}

// ExportGenesis returns the module's exported genesis
func ExportGenesis(ctx sdk.Context, k keeper.Keeper) *types.GenesisState {
	return &types.GenesisState{
		Params:       k.GetParams(ctx),
		DevEarnInfos: k.GetAllDevEarnInfos(ctx),
	}
}
